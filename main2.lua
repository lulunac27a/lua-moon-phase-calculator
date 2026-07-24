-- Moon phase calculation in Lua
local function getMoonPhase(year, month, day)                                           --function to calculate the moon phase for a given date
    -- 1. Base known New Moon: January 6, 2000
    local base_time = os.time({ year = 2000, month = 1, day = 6, hour = 18, min = 14 }) --base new moon date after new year 2000

    -- 2. Target date timestamp
    local target_time = os.time({ year = year, month = month, day = day }) --target date

    -- 3. Calculate seconds passed and convert to days
    local seconds_per_day = 86400
    local diff_days = (target_time - base_time) /
        seconds_per_day --difference in days between target date and base new moon date

    -- 4. Synodic month length (average lunar cycle in days)
    local lunar_cycle = 29.530588853 --average length of a lunar cycle in days

    -- 5. Calculate current age of the moon in days (0 to 29.53)
    local age = diff_days %
    lunar_cycle                                 --age of the moon in days, modulo the lunar cycle to get the current phase
    if age < 0 then age = age + lunar_cycle end --avoid negative age by adding the lunar cycle length if age is negative

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
    local angle = (age / lunar_cycle) * 2 * math.pi --moon angle
    local illumination = (1 - math.cos(angle)) / 2 *
        100                                         --illumination percentage based on the cosine of the angle in the lunar cycle

    return phase, math.floor(age * 100) / 100, math.floor(illumination)
end

local function promptNumber(message, default, min, max) --prompt user for a number with default and range validation
    while true do
        io.write(string.format("%s [%d]: ", message, default))
        local input = io.read()

        -- Use default if user just hits Enter
        if input == "" then return default end

        local num = tonumber(input)
        if num and num >= min and num <= max then
            return num
        end
        print(string.format("Invalid entry. Please enter a number between %d and %d.", min, max))
    end
end

local year = tonumber(arg[1])
local month = tonumber(arg[2])
local day = tonumber(arg[3])
if not year or not month or not day then --if any of the date components are missing, prompt the user for input
    print("--- Moon Phase Calculator ---")
    print("Press Enter to accept the current date defaults.\n")

    local today    = os.date("*t")
    year           = promptNumber("Enter Year", today.year, 1970, 2100)
    month          = promptNumber("Enter Month", today.month, 1, 12)

    -- Basic max day validation based on month
    local max_days = 31
    if month == 4 or month == 6 or month == 9 or month == 11 then
        max_days = 30
    elseif month == 2 then
        -- Leap year check
        if (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0) then max_days = 29 else max_days = 28 end
    end

    day = promptNumber("Enter Day", today.day, 1, max_days)
end
local date = { year = year, month = month, day = day }
if not year or not month or not day then --check if the date is still invalid after prompting
    print("No valid date provided. Defaulting to today's date.")
    local current_date = os.date("*t")
    year = tonumber(current_date.year)
    month = tonumber(current_date.month)
    day = tonumber(current_date.day)
end
local phase, age, illumination = getMoonPhase(date.year, date.month, date.day) --get the moon phase, age, and illumination for the provided date

print(string.format("Date: %04d-%02d-%02d", year, month, day))
print("Phase: " .. phase)
print("Age (Days): " .. age)
print("Illumination: " .. illumination .. "%")
