-- italicize_pathogens.lua
-- Italicize selected Latin names (genus alone + specific binomials).
-- Handles punctuation like "ramorum," and "(Pseudotsuga menziesii)".

local function split_punct(s)
  -- split leading and trailing punctuation: "(ramorum)," -> "(", "ramorum", "),"
  local lead, core, trail = s:match("^([%p]*)(.-)([%p]*)$")
  return lead or "", core or s, trail or ""
end

local function is_space(el) return el and el.t == "Space" end
local function is_str(el) return el and el.t == "Str" end

-- Phytophthora species to italicize as binomials when following the genus
local phyto_species = {
  cinnamomi = true,
  ramorum   = true,
  multivora = true
}

-- Generic binomials to italicize (Genus -> species set)
local binomials = {
  cryptostroma = { corticale = true },
  pseudotsuga  = { menziesii = true }
}

-- Normalize genus capitalization if typed lowercase
local genus_cap = {
  phytophthora = "Phytophthora",
  cryptostroma = "Cryptostroma",
  pseudotsuga  = "Pseudotsuga"
}

local function emph_words(words)
  local inl = {}
  for i, w in ipairs(words) do
    if i > 1 then table.insert(inl, pandoc.Space()) end
    table.insert(inl, pandoc.Str(w))
  end
  return pandoc.Emph(inl)
end

function Inlines(inlines)
  local out = {}
  local i = 1

  while i <= #inlines do
    local el = inlines[i]

    if is_str(el) then
      local lead1, core1, trail1 = split_punct(el.text)
      local lc1 = core1:lower()

      -- Case 1: Phytophthora (genus-only always italicized; binomial if species matches)
      if lc1 == "phytophthora" then
        local el2, el3 = inlines[i+1], inlines[i+2]

        if is_space(el2) and is_str(el3) then
          local lead3, core3, trail3 = split_punct(el3.text)
          local lc3 = core3:lower()

          if phyto_species[lc3] then
            if lead1 ~= "" then table.insert(out, pandoc.Str(lead1)) end
            table.insert(out, emph_words({"Phytophthora", lc3}))
            if trail3 ~= "" then table.insert(out, pandoc.Str(trail3)) end
            i = i + 3
          else
            if lead1 ~= "" then table.insert(out, pandoc.Str(lead1)) end
            table.insert(out, pandoc.Emph({pandoc.Str("Phytophthora")}))
            if trail1 ~= "" then table.insert(out, pandoc.Str(trail1)) end
            i = i + 1
          end
        else
          if lead1 ~= "" then table.insert(out, pandoc.Str(lead1)) end
          table.insert(out, pandoc.Emph({pandoc.Str("Phytophthora")}))
          if trail1 ~= "" then table.insert(out, pandoc.Str(trail1)) end
          i = i + 1
        end

      -- Case 2: Specific binomials (Cryptostroma corticale, Pseudotsuga menziesii)
      elseif binomials[lc1] ~= nil then
        local el2, el3 = inlines[i+1], inlines[i+2]
        if is_space(el2) and is_str(el3) then
          local lead3, core3, trail3 = split_punct(el3.text)
          local lc3 = core3:lower()

          if binomials[lc1][lc3] then
            local genus = genus_cap[lc1] or core1
            if lead1 ~= "" then table.insert(out, pandoc.Str(lead1)) end
            table.insert(out, emph_words({genus, lc3}))
            if trail3 ~= "" then table.insert(out, pandoc.Str(trail3)) end
            i = i + 3
          else
            -- passthrough but normalize genus casing if needed
            local genus = genus_cap[lc1] or core1
            table.insert(out, pandoc.Str(lead1 .. genus .. trail1))
            i = i + 1
          end
        else
          local genus = genus_cap[lc1] or core1
          table.insert(out, pandoc.Str(lead1 .. genus .. trail1))
          i = i + 1
        end

      else
        table.insert(out, el)
        i = i + 1
      end

    else
      table.insert(out, el)
      i = i + 1
    end
  end

  return out
end