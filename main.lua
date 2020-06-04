local DoubleTrouble = {}

DoubleTrouble.scriptName = "DoubleTrouble"

DoubleTrouble.cellDir = tes3mp.GetModDir() .. "/cell/"

DoubleTrouble.defaultConfig = {
    minimumCopies = 3,
    maximumCopies = 7,
    creatures = {
        "ascended_sleeper", "ash_ghoul", "ash_slave", "ash_zombie", "ash_zombie_fgaz", "corprus_stalker", "corprus_stalker_morvayn", "corprus_lame", "corprus_lame_morvayn", "alit", "alit_diseased", "alit_blighted", "cliff racer", "cliff racer_diseased", "cliff racer_blighted", "dreugh", "dreugh_koal", "guar_feral", "kagouti", "kagouti_mating", "kagouti_hrk", "kagouti_diseased", "kagouti_blighted", "mudcrab", "mudcrab-Diseased", "mudcrab_hrmudcrabnest", "netch_betty", "netch_bull", "nix-hound", "nix-hound blighted", "Rat", "rat_cave_fgrh", "rat_cave_fgt", "rat_diseased", "rat_blighted", "shalk", "shalk_diseased", "shalk_diseased_hram", "shalk_blighted", "Slaughterfish_Small", "slaughterfish", "slaughterfish_hr_sfavd", "atronach_flame", "atronach_flame_az", "atronach_flame_ttmk", "atronach_frost", "atronach_frost_ttmk", "atronach_frost_gwai_uni", "atronach_storm", "atronach_storm_az", "atronach_storm_ttmk", "clannfear", "daedroth", "daedroth_az", "daedroth_baladas", "daedroth_fg_nchur", "dremora", "dremora_lord", "golden saint", "hunger", "hunger_az_01", "hunger_az_02", "ogrim", "ogrim_az", "ogrim titan", "scamp", "winged twilight", "centurion_sphere", "centurion_sphere_nchur", "centurion_shock_baladas", "centurion_spider", "centurion_spider_nchur", "centurion_steam", "centurion_steam_nchur", "centurion_steam_advance", "centurion_projectile", "centurion_steam_A_C", "centurion_steam_C_L", "centurion_projectile_C", "kwama forager", "kwama forager_tb", "kwama forager blighted", "kwama warrior", "kwama warrior blighted", "kwama warrior shurdan", "kwama worker", "kwama worker entrance", "kwama worker diseased", "kwama worker blighted", "scrib", "scrib diseased", "scrib blighted", "ancestor_ghost", "bonelord", "bonewalker", "Bonewalker_Greater", "dwarven ghost", "skeleton_weak", "skeleton", "skeleton hero dead", "dead_skeleton", "skeleton entrance", "skeleton archer", "skeleton champion", "skeleton champ_sandas00", "skeleton champ_sandas10", "skeleton warrior", "worm lord", "durzog_wild_weaker", "durzog_diseased", "durzog_wild", "durzog_war_trained", "durzog_war", "fabricant_hulking_C", "fabricant_hulkin_attack", "fabricant_hulking_ss", "fabricant_hulking", "fabricant_hulking_C_L", "fabricant_machine_1", "fabricant_verm_attack", "fabricant_verminous", "fabricant_verminous_C", "fabricant_verminous-rs", "goblin_grunt", "goblin_footsoldier", "goblin_bruiser", "goblin_handler", "goblin_officer", "goblin_officerUNI", "lich", "ancestor_ghost_greater", "Imperfect", "Rat_plague", "BM_bear_black", "BM_bear_brown", "BM_ice_troll", "BM_ice_troll_tough", "BM_icetroll_FG_Uni", "BM_horker", "BM_horker_large", "BM_riekling", "BM_riekling_be_UNIQUE1", "BM_riekling_be_UNIQUE2", "BM_riekling_be_UNIQUE3", "BM_riekling_be_UNIQUE4", "BM_riekling_be_UNIQUE5", "BM_riekling_boarmaster", "BM_riekling_mounted", "BM_spriggan", "BM_frost_boar", "BM_wolf_grey_lvl_1", "BM_wolf_grey", "BM_wolf_hroldar", "BM_wolf_red", "atronach_frost_BM", "BM_wolf_skeleton", "BM_draugr01", "BM_draugr_bloodskal", "draugr", "draugr_co_3", "draugr_valbrandr", "draugr_aesliip", "skeleton nord", "skeleton_stahl_uni", "skeleton nord_2", "bm_skeleton_pirate", "bm skeleton champion gr", "bm_sk_champ_bloodskal01", "bm_sk_champ_bloodskal02"
    }
}

DoubleTrouble.config = DataManager.loadConfiguration(DoubleTrouble.scriptName, DoubleTrouble.defaultConfig)

DoubleTrouble.creatureCheck = {}

math.randomseed(os.time())

for k, v in pairs(DoubleTrouble.config.creatures) do
    DoubleTrouble.creatureCheck[v] = true
end

DoubleTrouble.visited = {}

function DoubleTrouble.isCreature(refId)
    return DoubleTrouble.creatureCheck[refId] ~= nil
end

function DoubleTrouble.getCopies()
    return math.random(DoubleTrouble.config.minimumCopies, DoubleTrouble.config.maximumCopies)
end

function DoubleTrouble.duplicate(cellDescription)
    local cellData = LoadedCells[cellDescription].data
    if cellData~=nil then
        local creatures = {}
        for _, uniqueIndex in pairs(cellData.packets.actorList) do
            if
                cellData.objectData[uniqueIndex].location ~= nil and
                DoubleTrouble.isCreature(cellData.objectData[uniqueIndex].refId)
            then
                table.insert(creatures, uniqueIndex)
            end
        end
        
        tes3mp.LogMessage(
            enumerations.log.INFO,
            "[DoubleTrouble] Cloning "..#creatures.."("..#cellData.packets.actorList..") creatures:"
        )

        for _, uniqueIndex in pairs(creatures) do
            local creature = cellData.objectData[uniqueIndex]

            tes3mp.LogMessage(enumerations.log.INFO, creature.refId)

            local copies = DoubleTrouble.getCopies()
            for i=2, copies do
                logicHandler.CreateObjectAtLocation(cellDescription, creature.location, creature.refId, "spawn")
            end
        end
    end
end


function DoubleTrouble.OnCellLoadValidator(eventStatus, pid, cellDescription)
    local cell = Cell(cellDescription)
    local cellFilePath = DoubleTrouble.cellDir .. cell.entryFile
    if tes3mp.DoesFileExist(cellFilePath) then
        DoubleTrouble.visited[cellDescription] = true
    end
end

function DoubleTrouble.OnActorList(eventStatus, pid, cellDescription)
    if DoubleTrouble.visited[cellDescription] == nil then
        DoubleTrouble.visited[cellDescription] = true
        DoubleTrouble.duplicate(cellDescription)
    end
end


customEventHooks.registerValidator("OnCellLoad", DoubleTrouble.OnCellLoadValidator)
customEventHooks.registerHandler("OnActorList", DoubleTrouble.OnActorList)


return DoubleTrouble