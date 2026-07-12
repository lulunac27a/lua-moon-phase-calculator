-- Moon phase calculation in Lua
local function getMoonPhase(year, month, day)
    -- 1. Base known New Moon: January 6, 2000
    local base_time = os.time({ year = 2000, month = 1, day = 6, hour = 18, min = 14 })

    -- 2. Target date timestamp
    local target_time = os.time({ year = year, month = month, day = day })

    -- 3. Calculate seconds passed and convert to days
    local seconds_per_day = 86400
    local diff_days = (target_time - base_time) / seconds_per_day

    -- 4. Synodic month length (average lunar cycle in days)
    local lunar_cycle = 29.530588853

    -- 5. Calculate current age of the moon in days (0 to 29.53)
    local age = diff_days % lunar_cycle
    if age < 0 then age = age + lunar_cycle end

    -- 6. Determine Phase Name
    local phase = ""
    if age < 1.84566 then
        phase = "New Moon"
    elseif age < 5.53699 then
        phase = "Waxing Crescent"
    elseif age < 9.22831 then
        phase = "First Quarter"
    elseif age < 12.91964 then
        phase = "Waxing Gibbous"
    elseif age < 16.61096 then
        phase = "Full Moon"
    elseif age < 20.30229 then
        phase = "Waning Gibbous"
    elseif age < 23.99361 then
        phase = "Third Quarter"
    elseif age < 27.68494 then
        phase = "Waning Crescent"
    else
        phase = "New Moon"
    end

    -- 7. Calculate Illumination Percentage (0% to 100%)
    -- Uses a simple cosine approximation based on the cycle position
    local angle = (age / lunar_cycle) * 2 * math.pi
    local illumination = (1 - math.cos(angle)) / 2 * 100

    return phase, math.floor(age * 100) / 100, math.floor(illumination)
end

local year = tonumber(arg[1])
local month = tonumber(arg[2])
local day = tonumber(arg[3])
local phase, age, illumination = getMoonPhase(year, month, day)

print(string.format("Date: %04d-%02d-%02d", year, month, day))
print("Phase: " .. phase)
print("Age (Days): " .. age)
print("Illumination: " .. illumination .. "%")
