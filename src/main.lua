local debug = false
local root_template = "Server/project/src/"

local utils = Ext.Require(root_template .. "modules/utils.lua")
local mod = "ebc37348-b345-4d49-a28f-c0491824d755"
local check_mod_status, mod_uuid = utils.check_mod_status(mod, debug)
local visual_type, question = utils.read_questions(1)-- Volothamp visual

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level, isEditorMode)
    if check_mod_status then
        if debug then
            utils.print_msg("check_mod_status: " .. tostring(check_mod_status), 0, 1)
            utils.print_msg("LevelGameplayStarted: " .. level .. " isEditorMode: " .. tostring(isEditorMode), 0, 1)
            utils.print_msg("is safe? true", 0, 1)
        end

        Ext.Osiris.RegisterListener("TemplateEquipped", 2, "after", function(item, character)
            local character_name, character_uuid = utils.get_character_data(character)
            if debug then
                utils.print_msg("", 2, 1)
                utils.print_msg("character........: " .. tostring(character), 2, 2)
                utils.print_msg("character_name...: " .. tostring(character_name), 2, 2)
                utils.print_msg("character_uuid...: " .. tostring(character_uuid), 2, 2)
                utils.print_msg("template_equipped: " .. tostring(item), 2, 2)
            end

            local item_name, item_template = utils.get_item_data(item)
            if debug then
                utils.print_msg("item_name........: " .. tostring(item_name), 2, 2)
                utils.print_msg("item_template....: " .. tostring(item_template), 2, 2)
            end

            local item_found, change_eye_color = utils.read_item(item_template, 1, false)
            if change_eye_color and item_found and mod_uuid == mod then

                Osi.OpenMessageBoxYesNo(character, question)

                Ext.Osiris.RegisterListener("MessageBoxYesNoClosed", 3, "after", function(char, msgbox, option)
                    if option == 1 then
                        utils.apply_material_ovveride(char, visual_type, debug)
                    end
                end)
                if debug then
                    utils.print_msg("item_found......: " .. tostring(item_found), 2, 2)
                    utils.print_msg("change_eye_color: " .. tostring(change_eye_color), 2, 2)
                end
            end
        end)

        Ext.Osiris.RegisterListener("TemplateUnequipped", 2, "after", function(item, character)
            local character_name, character_uuid = utils.get_character_data(character)
            if debug then
                utils.print_msg("", 2, 1)
                utils.print_msg("character........: " .. tostring(character), 2, 2)
                utils.print_msg("character_name...: " .. tostring(character_name), 2, 2)
                utils.print_msg("character_uuid...: " .. tostring(character_uuid), 2, 2)
                utils.print_msg("template_equipped: " .. tostring(item), 2, 2)
            end

            local item_name, item_template = utils.get_item_data(item)
            if debug then
                utils.print_msg("item_name........: " .. tostring(item_name), 2, 2)
                utils.print_msg("item_template....: " .. tostring(item_template), 2, 2)
            end

            local item_found, change_eye_color = utils.read_item(item_template, 1, false)
            if debug then
                utils.print_msg("item_found......: " .. tostring(item_found), 2, 2)
                utils.print_msg("change_eye_color: " .. tostring(change_eye_color), 2, 2)
            end
            if change_eye_color and item_found and mod_uuid == mod then
                utils.remove_material_ovveride(character, visual_type, debug)
            end
        end)
    end
end)
