local function ServerSave(name)
    local seconds = game.tick / 60
    local hours = string.format("%04.f", math.floor(seconds / 3600))
    local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
    local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))
    local time = string.format("%s_%s_%s", hours, mins, secs)

    local seed = game.surfaces[1].map_gen_settings.seed
    local save_name = string.format("%s_%s_%s", seed, time, name)
    if settings.global["MileStoneSaves_name"].value ~= "" then
        save_name = string.format("%s_%s_%s", settings.global["MileStoneSaves_name"].value, time, name)
    end

    if game.is_multiplayer() then
        game.server_save(save_name)
    else
        game.auto_save(save_name)
    end
end

local function IntervalServerSave(event)
    if event.tick == 0 then
        return
    end
    ServerSave("periodic")
end

local function ProductionChecks(event)
    if event.tick == 0 then
        return
    end
    for _, force in pairs(game.forces) do
        local produced = force["item_production_statistics"].input_counts

        if settings.global["MileStoneSaves_science"].value then
            local items = game.get_filtered_item_prototypes({{filter = "type", type = "tool"}})
            for _, item in pairs(items) do
                if global.milestones[item.name] == nil and produced[item.name] and produced[item.name] >= settings.global["MileStoneSaves_threshold"].value then
                    global.milestones[item.name] = true
                    ServerSave(item.name)
                end
            end
        end
    end
end

local function OnResearchFinished(event)
    if settings.global["MileStoneSaves_research"].value and global.milestones[event.research.name] == nil then
        global.milestones[event.research.name] = true
        ServerSave(event.research.name)
    end
end

local function OnRocketLaunched(event)
    if global.milestones["RocketLaunched"] == nil then
        global.milestones["RocketLaunched"] = true
        ServerSave("RocketLaunched")
    end
end

local function OnInit()
    global.milestones = global.milestones or {}
end

local function OnStartup()
    OnInit()
end

local function OnLoad()
    global.milestones = global.milestones or {}
end

script.on_init(OnStartup)
script.on_load(OnLoad)

script.on_nth_tick(settings.startup["MileStoneSaves_periodic"].value, IntervalServerSave)
script.on_nth_tick(settings.startup["MileStoneSaves_productivity"].value, ProductionChecks)

script.on_event(defines.events.on_research_finished, OnResearchFinished)
script.on_event(defines.events.on_rocket_launched, OnRocketLaunched)
