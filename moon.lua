local M = {}                              --module table to hold the moon phase calculation functions

local function normalize_age(age, cycle)  --normalize the age to be within the range of 0 to cycle
    age = age % cycle
    if age < 0 then age = age + cycle end --if age is negative, add cycle to make it positive
    return age
end

function M.getMoonPhase(year, month, day)                                              --calculate the moon phase for a given date
    -- Validate input
    if type(year) ~= "number" or type(month) ~= "number" or type(day) ~= "number" then --check if the input values are numbers
        error("Year, month, and day must be numbers")
    end
    local lunar_cycle = 29.530588853 --average length of a lunar cycle in days

    -- Reference new moon timestamp: 2000-01-06 18:14 UTC
    local base_time = os.time({ year = 2000, month = 1, day = 6, hour = 18, min = 14 }) --new moon reference date in seconds since epoch after new year 2000
    local target_time = os.time({ year = year, month = month, day = day })              --target date in seconds since epoch
    local seconds_per_day = 86400                                                       --seconds in a day
    local diff_days = (target_time - base_time) /
        seconds_per_day                                                                 --difference in days between the target date and the reference new moon

    local age = diff_days %
    lunar_cycle                                                                         --calculate the age of the moon in days since the last new moon
    age = normalize_age(age, lunar_cycle)                                               --ensure the age is within the range of 0 to lunar_cycle

    -- Compute percent through cycle and discrete 8-phase index (compatible with main.lua)
    local percent = age / lunar_cycle
    local phaseIndex = math.floor(percent * 8 + 0.5) % 8

    local phaseNames = { --moon phase names corresponding to the 8-phase indexes
        "New Moon",
        "Waxing Crescent",
        "First Quarter",
        "Waxing Gibbous",
        "Full Moon",
        "Waning Gibbous",
        "Last Quarter",
        "Waning Crescent",
    }

    local name = phaseNames
    [phaseIndex + 1]                        --get the name of the current moon phase based on the phase index

    local angle = (age / lunar_cycle) * 2 *
        math
        .pi --calculate the angle of the moon in its orbit based on its age and the length of the lunar cycle
    local illumination = (1 - math.cos(angle)) / 2 *
        100 --calculate the illumination percentage of the moon based on its angle in the orbit

    return {
        name = name,
        age = math.floor(age * 100) / 100,
        illumination = math.floor(illumination),
        percent = percent,
        index = phaseIndex,
    }
end

return M --return the module table containing the moon phase calculation functions
