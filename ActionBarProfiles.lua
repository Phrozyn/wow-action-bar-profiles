local addonName, addon = ...

LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceConsole-3.0", "AceTimer-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local qtip = LibStub('LibQTip-1.0')

local S2KFI = LibStub("LibS2kFactionalItems-1.0")

local MAX_ACTION_BUTTONS = 120
local PET_JOURNAL_FLAGS = { LE_PET_JOURNAL_FLAG_COLLECTED, LE_PET_JOURNAL_FLAG_NOT_COLLECTED }

local DEFAULT_PAPERDOLL_NUM_TABS = 3

local SIMILAR_ITEMS = {
    [6948]   = { 64488 },   -- Hearthstone
    [64488]  = { 6948 },    -- The Innkeeper's Daughter
    [118922] = { 86569, 75525 },    -- Oralius' Whispering Crystal
    [86569]  = { 118922, 75525 },   -- Crystal of Insanity
    [75525]  = { 118922, 86569 },   -- Alchemist's Flask
}

local SIMILAR_SPELLS = {
    -- mage portals
    [10059]  = { 11417 },   -- Portal: Stormwind
    [11416]  = { 11418 },   -- Portal: Ironforge
    [11419]  = { 11420 },   -- Portal: Darnassus
    [32266]  = { 32267 },   -- Portal: Exodar
    [49360]  = { 49361 },   -- Portal: Theramore
    [33691]  = { 35717 },   -- Portal: Shattrath
    [88345]  = { 88346 },   -- Portal: Tol Barad
    [132620] = { 132626 },  -- Portal: Vale of Eternal Blossoms
    [176246] = { 176244 },  -- Portal: Stormshield
    [11417]  = { 10059 },   -- Portal: Orgrimmar
    [11418]  = { 11416 },   -- Portal: Undercity
    [11420]  = { 11419 },   -- Portal: Thunder Bluff
    [32267]  = { 32266 },   -- Portal: Silvermoon
    [49361]  = { 49360 },   -- Portal: Stonard
    [35717]  = { 33691 },   -- Portal: Shattrath
    [88346]  = { 88345 },   -- Portal: Tol Barad
    [132626] = { 132620 },  -- Portal: Vale of Eternal Blossoms
    [176244] = { 176246 },  -- Portal: Warspear
    -- mage teleports
    [3561]   = { 3567 },    -- Teleport: Stormwind
    [3562]   = { 3563 },    -- Teleport: Ironforge
    [3565]   = { 3566 },    -- Teleport: Darnassus
    [32271]  = { 32272 },   -- Teleport: Exodar
    [49359]  = { 49358 },   -- Teleport: Theramore
    [33690]  = { 35715 },   -- Teleport: Shattrath
    [88342]  = { 88344 },   -- Teleport: Tol Barad
    [132621] = { 132627 },  -- Teleport: Vale of Eternal Blossoms
    [176248] = { 176242 },  -- Teleport: Stormshield
    [3567]   = { 3561 },    -- Teleport: Orgrimmar
    [3563]   = { 3562 },    -- Teleport: Undercity
    [3566]   = { 3565 },    -- Teleport: Thunder Bluff
    [32272]  = { 32271 },   -- Teleport: Silvermoon
    [49358]  = { 49359 },   -- Teleport: Stonard
    [35715]  = { 33690 },   -- Teleport: Shattrath
    [88344]  = { 88342 },   -- Teleport: Tol Barad
    [132627] = { 132621 },  -- Teleport: Vale of Eternal Blossoms
    [176242] = { 176248 },  -- Teleport: Warspear
}

local SPECIAL_SPELLS = {
    -- draenor zone ability
    [161691] = {
        level = 90,
        altSpellIds = { 161676, 161332, 162075, 161767, 170097, 170108, 168487, 168499, 164012, 164050, 165803, 164222, 160240, 160241 },
    },
    -- hunter pets
    [883]    = { class = 'HUNTER' },                    -- Call Pet 1
    [83242]  = { class = 'HUNTER', level = 10 },        -- Call Pet 2
    [83243]  = { class = 'HUNTER', level = 34 },        -- Call Pet 3
    [83244]  = { class = 'HUNTER', level = 62 },        -- Call Pet 4
    [83245]  = { class = 'HUNTER', level = 82 },        -- Call Pet 5
    [1462]   = { class = 'HUNTER', level = 12 },        -- Beast Lore
    [2641]   = { class = 'HUNTER', level = 10 },        -- Dismiss Pet
    [6991]   = { class = 'HUNTER', level = 11 },        -- Feed Pet
    [982]    = { class = 'HUNTER' },                    -- Revive Pet
    [1515]   = { class = 'HUNTER', level = 10 },        -- Tame Beast
    -- warlock daemons
    [688]    = { class = 'WARLOCK' },                   -- Summon Imp
    [697]    = { class = 'WARLOCK', level = 8 },        -- Summon Voidwalker
    [712]    = { class = 'WARLOCK', level = 28 },       -- Summon Succubus
    [691]    = { class = 'WARLOCK', level = 35 },       -- Summon FelHUNTER
    [30146]  = { class = 'WARLOCK', level = 40 },       -- Summon Felguard
    -- mage portals
    [53142]  = { class = 'MAGE', level = 74 },                          -- Portal: Dalaran - Northrend
    [224871] = { class = 'MAGE', level = 74 },                          -- Portal: Dalaran - Broken Isles
    [120146] = { class = 'MAGE', level = 74 },                          -- Ancient Portal: Dalaran
    [10059]  = { class = 'MAGE', level = 42, faction = 'Alliance' },    -- Portal: Stormwind
    [11416]  = { class = 'MAGE', level = 42, faction = 'Alliance' },    -- Portal: Ironforge
    [11419]  = { class = 'MAGE', level = 42, faction = 'Alliance' },    -- Portal: Darnassus
    [32266]  = { class = 'MAGE', level = 42, faction = 'Alliance' },    -- Portal: Exodar
    [49360]  = { class = 'MAGE', level = 42, faction = 'Alliance' },    -- Portal: Theramore
    [33691]  = { class = 'MAGE', level = 66, faction = 'Alliance' },    -- Portal: Shattrath
    [88345]  = { class = 'MAGE', level = 85, faction = 'Alliance' },    -- Portal: Tol Barad
    [132620] = { class = 'MAGE', level = 90, faction = 'Alliance' },    -- Portal: Vale of Eternal Blossoms
    [176246] = { class = 'MAGE', level = 92, faction = 'Alliance' },    -- Portal: Stormshield
    [11417]  = { class = 'MAGE', level = 42, faction = 'Horde' },       -- Portal: Orgrimmar
    [11418]  = { class = 'MAGE', level = 42, faction = 'Horde' },       -- Portal: Undercity
    [11420]  = { class = 'MAGE', level = 42, faction = 'Horde' },       -- Portal: Thunder Bluff
    [32267]  = { class = 'MAGE', level = 42, faction = 'Horde' },       -- Portal: Silvermoon
    [49361]  = { class = 'MAGE', level = 52, faction = 'Horde' },       -- Portal: Stonard
    [35717]  = { class = 'MAGE', level = 66, faction = 'Horde' },       -- Portal: Shattrath
    [88346]  = { class = 'MAGE', level = 85, faction = 'Horde' },       -- Portal: Tol Barad
    [132626] = { class = 'MAGE', level = 90, faction = 'Horde' },       -- Portal: Vale of Eternal Blossoms
    [176244] = { class = 'MAGE', level = 92, faction = 'Horde' },       -- Portal: Warspear
    -- mage teleports
    [193759] = { class = 'MAGE', level = 14 },                          -- Teleport: Hall of the Guardian
    [53140]  = { class = 'MAGE', level = 71 },                          -- Teleport: Dalaran - Northrend
    [224869] = { class = 'MAGE', level = 71 },                          -- Teleport: Dalaran - Broken Isles
    [120145] = { class = 'MAGE', level = 71 },                          -- Ancient Teleport: Dalaran
    [3561]   = { class = 'MAGE', level = 17, faction = 'Alliance' },    -- Teleport: Stormwind
    [3562]   = { class = 'MAGE', level = 17, faction = 'Alliance' },    -- Teleport: Ironforge
    [3565]   = { class = 'MAGE', level = 17, faction = 'Alliance' },    -- Teleport: Darnassus
    [32271]  = { class = 'MAGE', level = 17, faction = 'Alliance' },    -- Teleport: Exodar
    [49359]  = { class = 'MAGE', level = 17, faction = 'Alliance' },    -- Teleport: Theramore
    [33690]  = { class = 'MAGE', level = 62, faction = 'Alliance' },    -- Teleport: Shattrath
    [88342]  = { class = 'MAGE', level = 85, faction = 'Alliance' },    -- Teleport: Tol Barad
    [132621] = { class = 'MAGE', level = 90, faction = 'Alliance' },    -- Teleport: Vale of Eternal Blossoms
    [176248] = { class = 'MAGE', level = 92, faction = 'Alliance' },    -- Teleport: Stormshield
    [3567]   = { class = 'MAGE', level = 17, faction = 'Horde' },       -- Teleport: Orgrimmar
    [3563]   = { class = 'MAGE', level = 17, faction = 'Horde' },       -- Teleport: Undercity
    [3566]   = { class = 'MAGE', level = 17, faction = 'Horde' },       -- Teleport: Thunder Bluff
    [32272]  = { class = 'MAGE', level = 17, faction = 'Horde' },       -- Teleport: Silvermoon
    [49358]  = { class = 'MAGE', level = 52, faction = 'Horde' },       -- Teleport: Stonard
    [35715]  = { class = 'MAGE', level = 62, faction = 'Horde' },       -- Teleport: Shattrath
    [88344]  = { class = 'MAGE', level = 85, faction = 'Horde' },       -- Teleport: Tol Barad
    [132627] = { class = 'MAGE', level = 90, faction = 'Horde' },       -- Teleport: Vale of Eternal Blossoms
    [176242] = { class = 'MAGE', level = 92, faction = 'Horde' },       -- Teleport: Warspear
    -- rogue poisons
    [2823]   = { class = 'ROGUE', spec = 259, level = 2 },              -- Deadly Poison
    [3408]   = { class = 'ROGUE', spec = 259, level = 19 },             -- Crippling Poison
    [8679]   = { class = 'ROGUE', spec = 259, level = 25 },             -- Wound Poison
    [108211] = { class = 'ROGUE', spec = 259, level = 60 },             -- Leeching Poison
    [200802] = { class = 'ROGUE', spec = 259, level = 90 },             -- Agonizing Poison
}

function addon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New(addonName .. "DB", {
        profile = {
            minimap = {
                hide = false,
            },
        },
    }, true)

    if self.db.global.profiles then
        self.db.profile.profiles = self.db.global.profiles
        self.db.global.profiles = nil
    end

    self:InjectPaperDollSidebarTab(
        L.charframe_tab,
        "PaperDollActionBarProfilesPane",
        "Interface\\AddOns\\ActionBarProfiles\\textures\\CharDollBtn",
        { 0, 0.515625, 0, 0.13671875 }
    )

    self.ldb = LibStub('LibDataBroker-1.1'):NewDataObject(addonName, {
        type = 'launcher',
        --icon = 'Interface\\AddOns\\ActionBarProfiles\\textures\\CharDollBtnIcon',
        icon = 'Interface\\ICONS\\INV_Misc_Book_09',
        label = "Action Bar Profiles",
        OnEnter = function(...)
            self:UpdateTooltip(...)
        end,
        OnLeave = function()
        end,
        OnClick = function(obj, button)
            if button == 'RightButton' then
                InterfaceOptionsFrame_OpenToCategory(addonName)
            else
                ToggleCharacter('PaperDollFrame')
            end
        end,
    })

    self.icon = LibStub('LibDBIcon-1.0')
    self.icon:Register(addonName, self.ldb, self.db.profile.minimap)

    self:RegisterChatCommand("abp", "OnChatCommand")

    local options = self:GetOptions()

    LibStub('AceConfig-3.0'):RegisterOptionsTable(addonName, options)

    LibStub('AceConfigDialog-3.0'):AddToBlizOptions(addonName, nil, nil, "general")
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, options.args.profiles.name, addonName, "profiles")

    PaperDollActionBarProfilesPane:OnInitialize()
    PaperDollActionBarProfilesSaveDialog:OnInitialize()
end

function addon:UpdateTooltip(anchor)
    if not InCombatLockdown() and not (self.tooltip and self.tooltip:IsShown()) then
        if qtip:IsAcquired('ActionBarProfiles') and self.tooltip then
            self.tooltip:Clear()
        else
            self.tooltip = qtip:Acquire('ActionBarProfiles', 2, 'LEFT')

            self.tooltip.OnRelease = function()
                self.tooltip = nil
            end
        end

        self:UpdateTooltipData(self.tooltip)

        if anchor then
            self.tooltip:SmartAnchorTo(anchor)
            self.tooltip:SetAutoHideDelay(0.05, anchor)
        end

        self.tooltip:UpdateScrolling()
        self.tooltip:Show()
    end
end

function addon:UpdateTooltipData(tooltip)
    local playerClass = select(2, UnitClass("player"))
    local cache = addon:MakeCache()

    local lineNo

    local profile
    for profile in table.s2k_values(self:GetSortedProfiles()) do
        local coords = CLASS_ICON_TCOORDS[profile.class]

        if profile.icon then
            lineNo = tooltip:AddLine(string.format(
                '|T%s:14:14:0:0:32:32:0:32:0:32|t %-20s',
                profile.icon, profile.name
            ))
        else
            lineNo = tooltip:AddLine(string.format(
                '|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:14:14:0:0:256:256:%d:%d:%d:%d|t %-20s',
                coords[1] * 256, coords[2] * 256, coords[3] * 256, coords[4] * 256,
                profile.name
            ))
        end

        if profile.class == playerClass then
            if self:UseProfile(profile.name, true, cache) > 0 then
                tooltip:SetCellTextColor(lineNo, 1, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
            else
                tooltip:SetCellTextColor(lineNo, 1, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
            end
        else
            tooltip:SetCellTextColor(lineNo, 1, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
        end

        tooltip:SetLineScript(lineNo, 'OnMouseUp', function()
            tooltip:Hide()

            local fail, total = addon:UseProfile(profile.name, true)

            if fail > 0 then
                local popup = StaticPopup_Show("CONFIRM_USE_ACTION_BAR_PROFILE", fail, total)
                if popup then
                    popup.name = profile.name
                else
                    UIErrorsFrame:AddMessage(ERR_CLIENT_LOCKED_OUT, 1.0, 0.1, 0.1, 1.0)
                end
            else
                self:UseProfile(profile.name)
            end
        end)
    end

    if tooltip:GetLineCount() < 1 then
        lineNo = tooltip:AddLine(L.no_profiles)
        tooltip:SetCellTextColor(lineNo, 1, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
    end

    tooltip:AddLine()
end

function addon:OnChatCommand(message)
    local cmd, pos = self:GetArgs(message, 1, 1)
    local param = message:sub(pos)

    if cmd then
        if cmd == "use" then
            param = strtrim(param or "")

            if param ~= "" then
                local profile = self:GetProfile(strtrim(param), true)

                if profile then
                    self:UseProfile(profile.name)
                end
            end
        elseif cmd == "save" then
            param = strtrim(param or "")

            if param ~= "" then
                local profile = self:GetProfile(strtrim(param), true)

                if profile then
                    self:UpdateProfileBars(profile.name)
                else
                    self:SaveProfile(param, {})
                end

                PaperDollActionBarProfilesPane:Update()
            end
        elseif cmd == "delete" or cmd == "del" then
            param = strtrim(param or "")

            if param ~= "" then
                local profile = self:GetProfile(strtrim(param), true)

                if profile then
                    self:DeleteProfile(profile.name)
                    PaperDollActionBarProfilesPane:Update()
                end
            end
        elseif cmd == "list" then
            local profilesByClass = {}

            local profile
            for profile in table.s2k_values(self:GetSortedProfiles()) do
                profilesByClass[profile.class] = profilesByClass[profile.class] or {}

                table.insert(profilesByClass[profile.class], profile.name)
            end

            local locClasses = {}
            FillLocalizedClassList(locClasses)
            table.sort(locClasses)

            for class, locClass in pairs(locClasses) do
                if profilesByClass[class] then
                    self:Printf("%s: %s", locClass, strjoin(", ", unpack(profilesByClass[class])))
                end
            end
        end
    end
end

function addon:GetSimilarItems(itemId)
    local ret = SIMILAR_ITEMS[itemId]
    if ret then
        return unpack(ret)
    end
end

function addon:GetSimilarSpells(spellId)
    local ret = SIMILAR_SPELLS[spellId]
    if ret then
        return unpack(ret)
    end
end

function addon:GetSortedProfiles()
    local profiles = self.db.profile.profiles or {}
    local sorted = {}

    local k, v
    for k, v in pairs(profiles) do
        v.name = k
        table.insert(sorted, v)
    end

    local playerClass = select(2, UnitClass("player"))

    table.sort(sorted, function(a, b)
        if a.class == b.class then
            return a.name < b.name
        else
            return a.class == playerClass
        end
    end)

    return sorted
end

function addon:GetProfile(name, ignoreCase)
    local profile
    for profile in table.s2k_values(self:GetSortedProfiles()) do
        if profile.name == name or (ignoreCase and profile.name:lower() == name:lower()) then
            return profile
        end
    end
end

function addon:UseProfile(name, checkOnly, cache)
    local profiles = self.db.profile.profiles or {}
    local profile = profiles[name]

    local fail, total = 0, 0

    if profile then
        if not cache then
            cache = self:MakeCache()
        end

        local talents = {}

        local slot

        if not profile.skip_talents and profile.talents then
            for slot = 1, MAX_TALENT_TIERS do
                if profile.talents[slot] then
                    local id, name = unpack(profile.talents[slot])

                    local talentId = self:GetFromCache(cache.talents, id, name)
                    if talentId then
                        talents[talentId] = true

                        if not checkOnly then
                            LearnTalent(talentId)
                        end
                    else
                        fail = fail + 1
                    end

                    total = total + 1
                end
            end
        end

        if not checkOnly then
            cache.spells = self:PreloadSpells()
        end

        for slot = 1, MAX_ACTION_BUTTONS do
            local ok

            if profile.actions[slot] then
                local type, id, subType, extraId = unpack(profile.actions[slot])

                if type == "spell" then
                    if not profile.skip_spells then
                        ok = self:RestoreSpell(cache, profile, slot, checkOnly)

                        if not ok and subType == "talent" then
                            if talents[extraId] then
                                if not checkOnly then
                                    self:ScheduleTimer(function()
                                        self:PlaceTalentToSlot(slot, extraId)
                                    end, 0.5)
                                end

                                ok = true
                            end
                        end

                        total = total + 1
                        fail = fail + ((ok and 0) or 1)
                    end

                elseif type == "flyout" then
                    if not profile.skip_spells then
                        ok = self:RestoreFlyout(cache, profile, slot, checkOnly)

                        total = total + 1
                        fail = fail + ((ok and 0) or 1)
                    end

                elseif type == "item" then
                    if not profile.skip_items then
                        ok = self:RestoreItem(cache, profile, slot, checkOnly) or self:RestoreMissingItem(cache, profile, slot, checkOnly)

                        total = total + 1
                        fail = fail + ((ok and 0) or 1)
                    end

                elseif type == "companion" then
                    if not profile.skip_companions then
                        if subType == "MOUNT" then
                            ok = self:RestoreMount(cache, profile, slot, checkOnly)

                            total = total + 1
                            fail = fail + ((ok and 0) or 1)
                        end
                    end

                elseif type == "summonmount" then
                    if not profile.skip_companions then
                        ok = self:RestoreMount(cache, profile, slot, checkOnly)

                        total = total + 1
                        fail = fail + ((ok and 0) or 1)
                    end

                elseif type == "summonpet" then
                    if not profile.skip_companions then
                        ok = self:RestorePet(cache, profile, slot, checkOnly)

                        total = total + 1
                        fail = fail + ((ok and 0) or 1)
                    end

                elseif type == "macro" then
                    if id > 0 then
                        if not profile.skip_macros then
                            ok = self:RestoreMacro(cache, profile, slot, checkOnly)

                            total = total + 1
                            fail = fail + ((ok and 0) or 1)
                        end
                    end

                elseif type == "equipmentset" then
                    if not profile.skip_equip_sets then
                        ok = self:RestoreEquipSet(cache, profile, slot, checkOnly)

                        total = total + 1
                        fail = fail + ((ok and 0) or 1)
                    end
                end
            end

            if not ok and not profile.skip_empty_slots then
                self:ClearSlot(slot, checkOnly)
            end
        end

        if not profile.skip_pet_spells and HasPetSpells() and profile.petActions then
            for slot = 1, NUM_PET_ACTION_SLOTS do
                if not profile.skip_empty_slots then
                    self:ClearPetSlot(slot, checkOnly)
                end

                if profile.petActions[slot] then
                    total = total + 1
                    fail = fail + ((self:RestorePetSpell(cache, profile, slot, checkOnly) and 0) or 1)
                end
            end
        end

        if not (checkOnly or profile.skip_key_bindings) and profile.keyBindings then
            local i
            for i = 1, GetNumBindings() do
                local bind = { GetBinding(i) }
                if bind[3] then
                    local key
                    for key in table.s2k_values({ select(3, unpack(bind)) }) do
                        SetBinding(key)
                    end
                end
            end

            local cmd, keys
            for cmd, keys in pairs(profile.keyBindings) do
                local key
                for key in table.s2k_values(keys) do
                    SetBinding(key, cmd)
                end
            end

            SaveBindings(GetCurrentBindingSet())

            if LibStub('AceAddon-3.0'):GetAddon('Dominos', true) and profile.keyBindingsDominos then
                for i = 13, 60 do
                    local key
                    for key in table.s2k_values({ GetBindingKey(string.format("CLICK DominosActionButton%d:LeftButton", i)) }) do
                        SetBinding(key)
                    end

                    if profile.keyBindingsDominos[i] then
                        for key in table.s2k_values(profile.keyBindingsDominos[i]) do
                            SetBindingClick(key, string.format("DominosActionButton%d", i), "LeftButton")
                        end
                    end
                end
            end
        end
    end

    return fail, total
end

function addon:SaveProfile(name, options)
    local profiles = self.db.profile.profiles or {}
    self.db.profile.profiles = profiles

    profiles[name] = { name = name }

    self:UpdateProfileParams(name, nil, options)
    self:UpdateProfileBars(name)
end

function addon:UpdateProfileParams(name, rename, options)
    local profiles = self.db.profile.profiles or {}
    local profile = profiles[name]

    if profile then
        if rename and name ~= rename then
            profiles[name] = nil
            profiles[rename] = profile

            profile.name = rename
        end

        local k, v
        for k in pairs(profile) do
            if k:sub(1, 5) == "skip_" then
                profile[k] = nil
            end
        end

        for k, v in pairs(options) do
            profile[k] = v
        end
    end
end

function addon:UpdateProfileBars(name)
    local profiles = self.db.profile.profiles or {}
    local profile = profiles[name]

    if profile then
        profile.class = select(2, UnitClass("player"))
        profile.icon  = select(4, GetSpecializationInfo(GetSpecialization()))
        profile.owner = string.format("%s-%s", GetUnitName("player"), GetRealmName())

        local talents = {}

        profile.talents = {}

        local slot
        for slot = 1, MAX_TALENT_TIERS do
            local column
            for column = 1, NUM_TALENT_COLUMNS do
                local id, name, selected = table.s2k_select({ GetTalentInfo(slot, column, 1) }, 1, 2, 4)

                talents[name] = id

                if selected then
                    profile.talents[slot] = { id, name }
                end
            end
        end

        profile.actions = {}

        for slot = 1, MAX_ACTION_BUTTONS do
            local type, id, subType, extraId = GetActionInfo(slot)

            if type then
                if type == "item" then
                    profile.actions[slot] = { type, id, subType, extraId, ({ GetItemInfo(id) })[1] }

                elseif type == "macro" then
                    if id > 0 then
                        profile.actions[slot] = { type, id, subType, extraId, table.s2k_select({ GetMacroInfo(id) }, 1, 2) }
                    end

                elseif type == "summonpet" then
                    profile.actions[slot] = { type, id, subType, extraId, table.s2k_select({ C_PetJournal.GetPetInfoByPetID(id) }, 11, 8) }

                elseif type == "spell" then
                    local name, stance = GetSpellInfo(id)

                    if talents[name] then
                        subType, extraId = "talent", talents[name]
                    end

                    profile.actions[slot] = { type, id, subType, extraId, name, stance }
                else
                    profile.actions[slot] = { type, id, subType, extraId }
                end
            end
        end

        if HasPetSpells() then
            profile.petActions = {}

            local petSpells = self:PreloadPetSpells()

            for slot = 1, NUM_PET_ACTION_SLOTS do
                local name, stance, icon, isToken = GetPetActionInfo(slot)
                if name then
                    if not isToken and not self:GetFromCache(petSpells, icon) then
                        local spellIndex = self:GetFromCache(petSpells, icon, name, stance)
                        if spellIndex then
                            icon = GetSpellBookItemTexture(spellIndex, BOOKTYPE_PET)
                        end
                    end

                    profile.petActions[slot] = { name, stance, icon, isToken }
                end
            end
        else
            profile.petActions = nil
        end

        profile.keyBindings = {}

        local i
        for i = 1, GetNumBindings() do
            local bind = { GetBinding(i) }
            if bind[3] then
                profile.keyBindings[bind[1]] = { select(3, unpack(bind)) }
            end
        end

        if LibStub('AceAddon-3.0'):GetAddon('Dominos', true) then
            profile.keyBindingsDominos = {}

            for i = 13, 60 do
                local bind = { GetBindingKey(string.format("CLICK DominosActionButton%d:LeftButton", i)) }
                if #bind > 0 then
                    profile.keyBindingsDominos[i] = bind
                end
            end
        end
    end
end

function addon:DeleteProfile(name)
    local profiles = self.db.profile.profiles or {}
    profiles[name] = nil
end

function addon:ClearSlot(slot, checkOnly)
    if not checkOnly then
        ClearCursor()
        PickupAction(slot)
        ClearCursor()
    end
end

function addon:PlaceToSlot(slot, checkOnly)
    if not checkOnly then
        PlaceAction(slot)
        ClearCursor()
    end
end

function addon:PlaceItemToSlot(slot, itemId, checkOnly)
    if not checkOnly then
        PickupItem(itemId)
        self:PlaceToSlot(slot)
    end
end

function addon:PlaceSpellToSlot(slot, spellId, checkOnly)
    if not checkOnly then
        PickupSpell(spellId)
        self:PlaceToSlot(slot)
    end
end

function addon:PlaceTalentToSlot(slot, talentId, checkOnly)
    if not checkOnly then
        PickupTalent(talentId)
        self:PlaceToSlot(slot)
    end
end

function addon:ClearPetSlot(slot, checkOnly)
    if not checkOnly then
        ClearCursor()
        PickupPetAction(slot)
        ClearCursor()
    end
end

function addon:PlaceToPetSlot(slot, checkOnly)
    if not checkOnly then
        PickupPetAction(slot)
        ClearCursor()
    end
end

function addon:UpdateCache(cache, value, id, name, stance)
    cache.id[id] = value

    if name then
        if stance and stance ~= "" then
            local stName = name .. "|" .. stance
            cache.name[stName] = value
        end

        cache.name[name] = value
    end
end

function addon:GetFromCache(cache, id, name, stance)
    if cache.id[id] then
        return cache.id[id]
    end

    if name then
        if stance and stance ~= "" then
            local stName = name .. "|" .. stance
            if cache.name[stName] then
                return cache.name[stName]
            end
        end

        if cache.name[name] then
            return cache.name[name]
        end
    end
end

function addon:MakeCache()
    local talents = self:PreloadTalents()
    local spells, flyouts = self:PreloadSpells()
    local items = self:PreloadItems()
    local mounts = self:PreloadMounts()
    local pets = self:PreloadPets()
    local macros = self:PreloadMacros()
    local petSpells = self:PreloadPetSpells()

    return {
        talents = talents, spells = spells, flyouts = flyouts, items = items,
        mounts = mounts, pets = pets, macros = macros, petSpells = petSpells,
    }
end

function addon:PreloadTalents()
    local talents = { id = {}, name = {} }

    local tier
    for tier = 1, MAX_TALENT_TIERS do
        local avail = GetTalentTierInfo(tier, 1)
        if avail then
            local column
            for column = 1, NUM_TALENT_COLUMNS do
                local talentId, name = GetTalentInfo(tier, column, 1)

                self:UpdateCache(talents, talentId, talentId, name)
            end
        end
    end

    return talents
end

function addon:PreloadSpells()
    local spells = { id = {}, name = {} }
    local flyouts = { id = {}, name = {} }

    local bookTabs = {}

    local bookIndex
    for bookIndex = 1, GetNumSpellTabs() do
        local bookOffset, numSpells, offSpecId = table.s2k_select({ GetSpellTabInfo(bookIndex) }, 3, 4, 6)

        if bookOffset and offSpecId == 0 then
            table.insert(bookTabs, { type = BOOKTYPE_SPELL, from = bookOffset + 1, to = bookOffset + numSpells })
        end
    end

    local profIndex
    for profIndex in table.s2k_values({ GetProfessions() }) do
        if profIndex then
            local bookOffset, numSpells = table.s2k_select({ GetProfessionInfo(profIndex) }, 6, 5)

            table.insert(bookTabs, { type = BOOKTYPE_PROFESSION, from = bookOffset + 1, to = bookOffset + numSpells })
        end
    end

    local bookTab
    for bookTab in table.s2k_values(bookTabs) do
        local spellIndex
        for spellIndex = bookTab.from, bookTab.to do
            local type, spellId = GetSpellBookItemInfo(spellIndex, bookTab.type)
            local name, stance = GetSpellBookItemName(spellIndex, bookTab.type)

            if type == "SPELL" then
                self:UpdateCache(spells, spellId, spellId, name, stance)

            elseif type == "FLYOUT" then
                self:UpdateCache(flyouts, spellIndex, spellId, name)
            end
        end
    end

    local playerLevel   = UnitLevel("player")
    local playerClass   = select(2, UnitClass("player"))
    local playerFaction = UnitFactionGroup("player")
    local playerSpec    = GetSpecializationInfo(GetSpecialization())

    local spellId, altSpellId
    for spellId, info in pairs(SPECIAL_SPELLS) do
        if
            (not info.level or playerLevel >= info.level) and
            (not info.class or playerClass == info.class) and
            (not info.faction or playerFaction == info.faction) and
            (not info.spec or playerSpec == info.spec)
        then
            self:UpdateCache(spells, spellId, spellId)

            if info.altSpellIds then
                for altSpellId in table.s2k_values(info.altSpellIds) do
                    self:UpdateCache(spells, spellId, altSpellId)
                end
            end
        end
    end

    return spells, flyouts
end

function addon:PreloadItems()
    local items = { id = {}, name = {} }
    local levels = {}

    local slotIndex
    for slotIndex = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local itemId = GetInventoryItemID("player", slotIndex)

        if itemId then
            local name, level = table.s2k_select({ GetItemInfo(itemId) }, 1, 4)

            if not levels[name] or level > levels[name] then
                self:UpdateCache(items, itemId, itemId, name)
                levels[name] = level
            else
                self:UpdateCache(items, itemId, itemId)
            end
        end
    end

    local bagIndex
    for bagIndex = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        local itemIndex
        for itemIndex = 1, GetContainerNumSlots(bagIndex) do
            local itemId = GetContainerItemID(bagIndex, itemIndex)

            if itemId then
                local name, level = table.s2k_select({ GetItemInfo(itemId) }, 1, 4)

                if not levels[name] or level > levels[name] then
                    self:UpdateCache(items, itemId, itemId, name)
                    levels[name] = level
                else
                    self:UpdateCache(items, itemId, itemId)
                end
            end
        end
    end

    return items
end

function addon:PreloadMounts()
    local mounts = { id = {}, name = {} }

    local playerFaction = (UnitFactionGroup("player") == "Alliance" and 1) or 0
    local allMounts = C_MountJournal.GetMountIDs()

    local mountId
    for mountId in table.s2k_values(allMounts) do
        local name, spellId, faction, isCollected = table.s2k_select({ C_MountJournal.GetMountInfoByID(mountId) }, 1, 2, 9, 11)

        if isCollected and (not faction or faction == playerFaction) then
            self:UpdateCache(mounts, spellId, spellId, name)
        end
    end

    return mounts
end

function addon:PreloadPets()
    local pets = { id = {} }

    local saved = self:SavePetJournalFilters()

    C_PetJournal.ClearSearchFilter()

    C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, true)
    C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, true)

    C_PetJournal.SetAllPetSourcesChecked(true)
    C_PetJournal.SetAllPetTypesChecked(true)

    local petIndex
    for petIndex = 1, C_PetJournal:GetNumPets() do
        local petId, creatureId = table.s2k_select({ C_PetJournal.GetPetInfoByIndex(petIndex) }, 1, 11)
        self:UpdateCache(pets, petId, creatureId)
    end

    self:RestorePetJournalFilters(saved)

    return pets
end

function addon:PreloadMacros()
    local macros = { id = {}, name = {} } -- id - "name|icon", name - "name"

    local macroIndex
    for macroIndex = 1, MAX_ACCOUNT_MACROS + MAX_CHARACTER_MACROS do
        local name, icon = GetMacroInfo(macroIndex)

        if name and name ~= "" and icon then
            self:UpdateCache(macros, macroIndex, name .. "|" .. icon, name)
        end
    end

    return macros
end

function addon:PreloadPetSpells()
    local petSpells = { id = {}, name = {} } -- id - "icon"

    local numSpells = HasPetSpells()
    if numSpells then
        local spellIndex
        for spellIndex = 1, numSpells do
            local name, stance = GetSpellBookItemName(spellIndex, BOOKTYPE_PET)
            local icon = GetSpellBookItemTexture(spellIndex, BOOKTYPE_PET)

            self:UpdateCache(petSpells, spellIndex, icon, name, stance)
        end
    end

    return petSpells
end

function addon:RestoreSpell(cache, profile, slot, checkOnly)
    local id = profile.actions[slot][2]
    local name, stance = GetSpellInfo(id)

    local spellId = self:GetFromCache(cache.spells, id, name, stance)

    if spellId then
        self:PlaceSpellToSlot(slot, spellId, checkOnly)
        return true
    end

    for spellId in table.s2k_values({ self:GetSimilarSpells(id) }) do
        if cache.spells.id[spellId] then
            self:PlaceSpellToSlot(slot, spellId, checkOnly)
            return true
        end
    end
end

function addon:RestoreFlyout(cache, profile, slot, checkOnly)
    local id = profile.actions[slot][2]
    local name = GetFlyoutInfo(id)

    local flyoutIndex = self:GetFromCache(cache.flyouts, id, name)

    if flyoutIndex then
        if not checkOnly then
            PickupSpellBookItem(flyoutIndex, BOOKTYPE_SPELL)
            self:PlaceToSlot(slot)
        end
        return true
    end
end

function addon:RestoreItem(cache, profile, slot, checkOnly)
    local id = profile.actions[slot][2]
    local name = GetItemInfo(id) or profile.actions[slot][5]

    if PlayerHasToy(id) then
        self:PlaceItemToSlot(slot, id, checkOnly)
        return true
    end

    local itemId = self:GetFromCache(cache.items, id, name)

    if itemId then
        self:PlaceItemToSlot(slot, itemId, checkOnly)
        return true
    end

    local factItemId = S2KFI:GetConvertedItemId(id)

    if factItemId then
        local factItemName = GetItemInfo(factItemId)

        itemId = self:GetFromCache(cache.items, factItemId, factItemName)

        if itemId then
            self:PlaceItemToSlot(slot, itemId, checkOnly)
            return true
        end
    end

    for itemId in table.s2k_values({ self:GetSimilarItems(id) }) do
        if cache.items.id[itemId] then
            self:PlaceItemToSlot(slot, itemId, checkOnly)
            return true
        end
    end
end

function addon:RestoreMissingItem(cache, profile, slot, checkOnly)
    local id = profile.actions[slot][2]

    local itemId = S2KFI:GetConvertedItemId(id) or id

    if GetItemInfo(itemId) then
        self:PlaceItemToSlot(slot, itemId, checkOnly)
        return true
    end
end

function addon:RestoreMount(cache, profile, slot, checkOnly)
    local type, id = unpack(profile.actions[slot])

    if type == "summonmount" then
        if id == 0xFFFFFFF then
            if not checkOnly then
                C_MountJournal.Pickup(0)
                self:PlaceToSlot(slot)
            end
            return true
        end

        id = select(2, C_MountJournal.GetMountInfoByID(id))
    end

    local name = GetSpellInfo(id)
    local spellId = self:GetFromCache(cache.mounts, id, name)

    if spellId then
        self:PlaceSpellToSlot(slot, spellId, checkOnly)
        return true
    end
end

function addon:RestorePet(cache, profile, slot, checkOnly)
    local id = profile.actions[slot][5]

    local petId = self:GetFromCache(cache.pets, id)

    if petId then
        if not checkOnly then
            C_PetJournal.PickupPet(petId)
            self:PlaceToSlot(slot)
        end
        return true
    end
end

function addon:RestoreMacro(cache, profile, slot, checkOnly)
    local name, icon = table.s2k_select(profile.actions[slot], 5, 6)

    local macroIndex = self:GetFromCache(cache.macros, name .. "|" .. icon, name)

    if macroIndex then
        if not checkOnly then
            PickupMacro(macroIndex)
            self:PlaceToSlot(slot)
        end
        return true
    end
end

function addon:RestoreEquipSet(cache, profile, slot, checkOnly)
    local name = profile.actions[slot][2]

    if GetEquipmentSetInfoByName(name) then
        if not checkOnly then
            PickupEquipmentSetByName(name)
            self:PlaceToSlot(slot)
        end
        return true
    end
end

function addon:RestorePetSpell(cache, profile, slot, checkOnly)
    local icon, isToken = table.s2k_select(profile.petActions[slot], 3, 4)

    icon = (isToken and _G[icon]) or icon

    local spellIndex = self:GetFromCache(cache.petSpells, icon)

    if spellIndex then
        if not checkOnly then
            PickupSpellBookItem(spellIndex, BOOKTYPE_PET)
            self:PlaceToPetSlot(slot)
        end
        return true
    end
end

function addon:SavePetJournalFilters()
    local saved = { flag = {}, source = {}, type = {} }

    saved.text = C_PetJournal.GetSearchFilter()

    local i
    for i in table.s2k_values(PET_JOURNAL_FLAGS) do
        saved.flag[i] = C_PetJournal.IsFilterChecked(i)
    end

    for i = 1, C_PetJournal.GetNumPetSources() do
        saved.source[i] = C_PetJournal.IsPetSourceChecked(i)
    end

    for i = 1, C_PetJournal.GetNumPetTypes() do
        saved.type[i] = C_PetJournal.IsPetTypeChecked(i)
    end

    return saved
end

function addon:RestorePetJournalFilters(saved)
    C_PetJournal.SetSearchFilter(saved.text)

    local i
    for i in table.s2k_values(PET_JOURNAL_FLAGS) do
        C_PetJournal.SetFilterChecked(i, saved.flag[i])
    end

    for i = 1, C_PetJournal.GetNumPetSources() do
        C_PetJournal.SetPetSourceChecked(i, saved.source[i])
    end

    for i = 1, C_PetJournal.GetNumPetTypes() do
        C_PetJournal.SetPetTypeFilter(i, saved.type[i])
    end
end

function addon:InjectPaperDollSidebarTab(name, frame, icon, texCoords)
    self:Fix3rdPartyAddons()

    local tabIndex = #PAPERDOLL_SIDEBARS + 1
    local extraTabs = tabIndex - DEFAULT_PAPERDOLL_NUM_TABS

    PAPERDOLL_SIDEBARS[tabIndex] = { name = name, frame = frame, icon = icon, texCoords = texCoords }

    CreateFrame(
        "Button", "PaperDollSidebarTab" .. tabIndex, PaperDollSidebarTabs,
        "PaperDollSidebarTabTemplate", tabIndex
    )

    self:LineUpPaperDollSidebarTabs()

    if not self.prevSetLevel then
        self.prevSetLevel = PaperDollFrame_SetLevel

        PaperDollFrame_SetLevel = function(...)
            self.prevSetLevel(...)

            local extraTabs = #PAPERDOLL_SIDEBARS - DEFAULT_PAPERDOLL_NUM_TABS

            if CharacterFrameInsetRight:IsVisible() then
                local i
                for i = 1, CharacterLevelText:GetNumPoints() do
                    point, relativeTo, relativePoint, xOffset, yOffset = CharacterLevelText:GetPoint(i)

                    if point == "CENTER" then
                        CharacterLevelText:SetPoint(
                            point, relativeTo, relativePoint,
                            xOffset - (20 + 10 * extraTabs), yOffset
                        )
                    end
                end
            end
        end
    end

    if not self.prevOnUpdate then
        self.prevOnUpdate = PaperDollSidebarTabs:GetScript("OnUpdate") or function() end

        PaperDollSidebarTabs:SetScript("OnUpdate", function(...)
            self.prevOnUpdate(...)
            self:Fix3rdPartyAddons()
        end)
    end
end

function addon:LineUpPaperDollSidebarTabs()
    local extraTabs = #PAPERDOLL_SIDEBARS - DEFAULT_PAPERDOLL_NUM_TABS

    local i, prevTab

    for i = 1, #PAPERDOLL_SIDEBARS do
        local tab = _G["PaperDollSidebarTab" .. i]
        if tab then
            tab:ClearAllPoints()
            tab:SetPoint("BOTTOMRIGHT", (extraTabs < 2 and -20) or (extraTabs < 3 and -10) or 0, 0)

            if prevTab then
                prevTab:ClearAllPoints()
                prevTab:SetPoint("RIGHT", tab, "LEFT", -4, 0)
            end

            prevTab = tab
        end
    end
end

function addon:Fix3rdPartyAddons()
    self:FixZygorGuideViewer()
end

function addon:FixZygorGuideViewer()
    if ZGVCharacterGearFinderButton and not self.fixedZGV then
        local i
        for i = 1, #PAPERDOLL_SIDEBARS do
            if PAPERDOLL_SIDEBARS[i].frame == "ZygorGearFinderFrame" then
                ZGVCharacterGearFinderButton:SetID(i)

                ZGVCharacterGearFinderButton.Icon:SetTexture(PAPERDOLL_SIDEBARS[i].icon)
                ZGVCharacterGearFinderButton.Icon:SetTexCoord(unpack(PAPERDOLL_SIDEBARS[i].texCoords))

                _G["PaperDollSidebarTab" .. i] = ZGVCharacterGearFinderButton
            end
        end

        self:LineUpPaperDollSidebarTabs()
        self.fixedZGV = true
    end
end
