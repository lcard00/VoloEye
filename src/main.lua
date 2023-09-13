local debug = false
local root_template = "Server/project/src/"

local utils = Ext.Require(root_template .. "modules/utils.lua")

-- check if the mod is loaded
local check_mod_status, mod_uuid = utils.check_mod_status("ebc37348-b345-4d49-a28f-c0491824d755", debug)

if check_mod_status then
    Ext.Osiris.RegisterListener("TemplateEquipped", 2, "after", function(item, character)
        -- put code here to equipped template
        local character_name, character_uuid = utils.get_character_data(character)

        if debug then
            utils.print_msg("", 2, 1)
            utils.print_msg("character........: " .. character, 2, 2)
            utils.print_msg("character_name...: " .. character_name, 2, 2)
            utils.print_msg("character_uuid...: " .. character_uuid, 2, 2)
            utils.print_msg("template_equipped: " .. item, 2, 2)
        end

        local item_name, item_template = utils.get_item_data(item)

        if debug then
            utils.print_msg("item_name........: " .. item_name, 2, 2)
            utils.print_msg("item_template....: " .. item_template, 2, 2)
        end

        local item_found, change_eye_color = utils.read_item(item_template, 1, false)


        if change_eye_color and item_found and mod_uuid == "ebc37348-b345-4d49-a28f-c0491824d755" then
            local visual_type = 2
            local question = utils.read_questions(2)

            Osi.OpenMessageBoxYesNo(character, question)

            Ext.Osiris.RegisterListener("MessageBoxYesNoClosed", 3, "after", function(char, msgbox, option)
                if option == 1 then
                    utils.apply_material_ovveride(char, visual_type)
                end
            end)

            if debug then
                utils.print_msg("item_found......: " .. item_found, 2, 2)
                utils.print_msg("change_eye_color: " .. change_eye_color, 2, 2)
            end
        end
    end)
    Ext.Osiris.RegisterListener("TemplateUnequipped", 2, "after", function(item, character)
        -- put code here to unnequipped template
        local character_name, character_uuid = utils.get_character_data(character)

        if debug then
            utils.print_msg("", 2, 1)
            utils.print_msg("character........: " .. character, 2, 2)
            utils.print_msg("character_name...: " .. character_name, 2, 2)
            utils.print_msg("character_uuid...: " .. character_uuid, 2, 2)
            utils.print_msg("template_equipped: " .. item, 2, 2)
        end

        local item_name, item_template = utils.get_item_data(item)

        if debug then
            utils.print_msg("item_name........: " .. item_name, 2, 2)
            utils.print_msg("item_template....: " .. item_template, 2, 2)
        end

        local item_found, change_eye_color = utils.read_item(item_template, 1, false)

        if debug then
            utils.print_msg("item_found......: " .. item_found, 2, 2)
            utils.print_msg("change_eye_color: " .. change_eye_color, 2, 2)
        end

        if change_eye_color and item_found and mod_uuid == "ebc37348-b345-4d49-a28f-c0491824d755" then
            utils.remove_material_ovveride(character, 2, false)
        end
    end)
end
