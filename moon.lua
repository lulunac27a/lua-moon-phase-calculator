local M = {}

local function normalize_age(age, cycle)
    if age < 0 then age = age + cycle end
    return age
end

function M.getMoonPhase(year, month, day)
    local lunar_cycle = 29.530588853

    -- Reference new moon timestamp: 2000-01-06 18:14 UTC
    local base_time = os.time({year = 2000, month = 1, day = 6, hour = 18, min = 14})
    local target_time = os.time({year = year, month = month, day = day})
    local seconds_per_day = 86400
    local diff_days = (target_time - base_time) / seconds_per_day

    local age = diff_days % lunar_cycle
    age = normalize_age(age, lunar_cycle)

    -- Compute percent through cycle and discrete 8-phase index (compatible with main.lua)
    local percent = age / lunar_cycle
    local phaseIndex = math.floor(percent * 8 + 0.5) % 8

    local phaseNames = {
        "New Moon",
        "Waxing Crescent",
        "First Quarter",
        "Waxing Gibbous",
        "Full Moon",
        "Waning Gibbous",
        "Last Quarter",
        "Waning Crescent",
    }

    local name = phaseNames[phaseIndex + 1]

    local angle = (age / lunar_cycle) * 2 * math.pi
    local illumination = (1 - math.cos(angle)) / 2 * 100

    return {
        name = name,
        age = math.floor(age * 100) / 100,
        illumination = math.floor(illumination),
        percent = percent,
        index = phaseIndex,
    }
end

return M
