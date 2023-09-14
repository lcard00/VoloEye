---@meta

-- Enum Types
---@alias item_status enum
---| `0` # unnequipped
---| `1` # equipped
---@alias print_type enum
---| `0` # warning
---| `1` # error
---| `2` # default
---@alias print_identity enum
---| `0` # space
---| `1` # enter
---| `2` # tab
---| `3` # default 
---@alias table_type enum
---| `0` # root_template
---| `1` # custom_root_template
---| `2` # material_override
---| `3` # questions
---@alias override_preset enum
---| `1` # CAMP_Volo_ErsatzEye
---| `2` # HalfIllithid
---| `3` # S_HAG_LeftEyeBlind
---| `4` # S_HAG_RightEyeBlind

local debug = false
local utils = {}
local root_dir = "Server/project/src/"
local DBTemplate = Ext.Require(root_dir .. "database/DBTemplate.lua")


---@param type print_type
---@param type_identity print_identity
function utils.print_msg(msg, type, type_identity)
    if not type_identity then
        type_identity = 3
    end
    if type == 0 and type_identity == 0 then
        Ext.Utils.PrintWarning(" " .. msg .. " ")
    elseif type == 1 and type_identity == 0 then
        error(" " .. msg .. " ")
    elseif type == 2 and type_identity == 0 then
        Ext.Utils.Print(" " .. msg .. " ")
    elseif type == 0 and type_identity == 1 then
        Ext.Utils.PrintWarning("\n" .. msg .. "\n")
    elseif type == 1 and type_identity == 1 then
        error("\n" .. msg .. "\n")
    elseif type == 2 and type_identity == 1 then
        Ext.Utils.Print("\n" .. msg .. "\n")
    elseif type == 0 and type_identity == 2 then
        Ext.Utils.PrintWarning("    " .. msg .. "   ")
    elseif type == 1 and type_identity == 2 then
        error("    " .. msg .. "    ")
    elseif type == 2 and type_identity == 2 then
        Ext.Utils.Print("    " .. msg .. "    ")
    elseif type == 0 and type_identity == 3 then
        Ext.Utils.PrintWarning(msg)
    elseif type == 1 and type_identity == 3 then
        error(msg)
    elseif type == 2 and type_identity == 3 then
        Ext.Utils.Print(msg)
    end
end

if DBTemplate and debug then
    utils.print_msg("DBTemplate loaded successful", 0, 1)
elseif not DBTemplate and debug then
    utils.print_msg("Failed to load DBTemplate, please check the mod installation", 1, 1)
end

function utils.get_error_message(error_details)
    return utils.print_msg(error_details, 1, 1)
end

function utils.check_mod_status(mod_uuid, debug)
    local check_mod_status = Ext.Mod.IsModLoaded(mod_uuid)
    if check_mod_status then
        if debug then
            utils.print_msg("Mod " .. mod_uuid .. " is loaded", 0, 1)
        end
        
        return true, mod_uuid
    else
        if debug then
            utils.print_msg("Mod " .. mod_uuid .. " not loaded. Please check BG3 Modmanager and try again", 1, 1)
        end

        return false, mod_uuid
    end
end

function utils.get_item_data(item, debug)
    local item_name = string.match(item, "^(.-)_[a-fA-F0-9-]+$")
    local item_template = string.sub(item, -36)

    if debug then
        utils.print_msg("item_name: " .. item_name .. " item_template: " .. item_template, 0, 2)
    end

    return item_name, item_template
end

function utils.get_character_data(character, debug)
    local character_name = string.match(character, "^(.-)_[a-fA-F0-9-]+$")
    local character_uuid = string.sub(character, -36)
    
    if debug then
        utils.print_msg("character_name: " .. character_name .. " uuid: " .. character_uuid, 0, 2)
    end

    return character_name, character_uuid
end

---@param type table_type
---@return table items
local function read_db(type, debug)
    local items = {}
    if type == 0 then
        for key, item in pairs(DBTemplate.root_template) do
            if debug then
                utils.print_item(item)
            end
            
            table.insert(items, item)
        end
    elseif type == 1 then
        for key, item in pairs(DBTemplate.custom_root_template) do
            if debug then
                utils.print_item(item)
            end

            table.insert(items, item)
        end
    elseif type == 2 then
        for key, item in pairs(DBTemplate.material_override) do
            if debug then
                utils.print_item(item)
            end

            table.insert(items, item)
        end
    elseif type == 3 then
        for key, item in pairs(DBTemplate.questions) do
            if debug then
                utils.print_item(item)
            end

            table.insert(items, item)
        end
    else
        utils.print_msg("Invalid table type", 1, 1)
    end
    return items
end

function utils.print_item(item)
    utils.print_msg("item_name.........: " .. item.item_name, 2, 2)
    utils.print_msg("name_localization.: " .. item.name_localization, 2, 2)
    utils.print_msg("item_handle.......: " .. item.item_handle, 2, 2)
    utils.print_msg("description.......: " .. item.description, 2, 2)
    utils.print_msg("map_key...........: " .. item.map_key, 2, 2)
    utils.print_msg("parent_template_id: " .. item.parent_template_id, 2, 2)
    utils.print_msg("stats.............: " .. item.stats, 2, 2)
end

---@param debug boolean
---@return boolean item_found, boolean change_eye_color
function utils.read_item(item_data, status, debug)
    local change_eye_color = false
    local item_found = false
    
    if item_data then
        if debug then
            utils.print_msg("read_item: " .. item_data, 0, 1)
        end

        local success, error_details = pcall(function()
            local items = read_db(1)
            for key, item in pairs(items) do
                if item.map_key == item_data then
                    item_found = true
                    change_eye_color = true

                    if item_found == 1 and debug then
                        utils.print_item(item)
                    elseif item_found == 0 and debug then
                        utils.print_msg("Item " .. item.item_name .. item.map_key .. " not found in database DBTemplate, table custom_root_template", 0, 1)
                    end
                    
                    return item_found, change_eye_color
                elseif item.item_name == item_data then
                    item_found = true
                    change_eye_color = true
                    
                    if item_found and debug == 0 then
                        utils.print_item(item)
                    elseif item_found and debug then
                        utils.print_msg("Item " .. item.item_name .. item.map_key .. " not found in database DBTemplate, table custom_root_template", 0, 1)
                    end
                end
            end
        end)
        if not success then
            utils.print_msg(error_details, 1, 2)
        end
    end
    return item_found, change_eye_color
end

local function get_material_override(type) 
    local uuid = ""

    if type == 1 then 
        uuid = "dc46662a-d909-4df5-ad12-50a524150aff" -- Volo
    elseif type == 2 then
        uuid = "398ca8ae-c3c0-47f5-8e45-d9402e198389" -- HalfIllithid
    elseif type == 3 then
        uuid = "a2a75f90-4bdf-4009-97f4-e34363c82acc" -- Left Hag
    elseif type == 4 then
        uuid = "5c386818-daf8-4d54-9a40-1aa29702d968" -- Right Hag
    end
    
    if debug then
        utils.pring_msg("Type: " .. type .. " uuid: " .. uuid)
    end

    return uuid
end

---@param type override_preset 
function utils.apply_material_ovveride(character, type, debug)
    local materials = read_db(2)
    local uuid = get_material_override(type)

    if materials then
        for key, material in pairs(materials) do
            if material.uuid == uuid then
                Osi.AddCustomMaterialOverride(character, material.uuid)

                if debug then
                    utils.print_msg("Applying material: " .. material.preset_name .. " - " .. material.uuid, 0, 1)
                end
            end
        end
    end
end

---@param type override_preset 
function utils.remove_material_ovveride(character, type, debug)
    local materials = read_db(2)
    local uuid = get_material_override(type)

    if materials then
        for key, material in pairs(materials) do
            if material.uuid == uuid then
                Osi.RemoveCustomMaterialOverride(character, material.uuid)

                if debug then
                    utils.print_msg("Removing material: " .. material.preset_name .. " - " .. material.uuid, 0, 1)
                end
            end
        end
    end
end

function utils.read_questions(id)
    local questions = read_db(3)
    local question_list = {}

    for _, question in pairs(questions) do
        if _ == id then
            return question.question
        end
    end
end

return utils
