local function getMoonPhase(year, month, day) --function to calculate the moon phase based on the provided date
    -- Known New Moon reference point: January 6, 2000
    local refYear = 2000
    local refMonth = 1
    local refDay = 6

    -- Synodic month (days it takes to complete a full lunar cycle)
    local synodicMonth = 29.5305882 --in days

    -- Convert Gregorian date to Julian Day (approximate)
    if month < 3 then
        year = year - 1
        month = month + 12
    end
    month = month + 1

    local c = 365.25 * year
    local e = math.floor(30.6 * month)
    local julianDays = c + e + day - 694039.09

    -- Calculate days elapsed since the reference new moon
    local daysElapsed = julianDays % synodicMonth --days since the last new moon

    -- Percentage of the lunar cycle completed (0.0 to 1.0)
    local percent = daysElapsed / synodicMonth --percentage of the lunar cycle completed

    -- Map the cycle to an 8-phase index (0-7)
    local phaseIndex = math.floor((daysElapsed / synodicMonth) * 8 + 0.5) % 8

    local phaseNames = {
        "New Moon",
        "Waxing Crescent",
        "First Quarter",
        "Waxing Gibbous",
        "Full Moon",
        "Waning Gibbous",
        "Last Quarter",
        "Waning Crescent"
    }

    return {
        percent = percent,
        index = phaseIndex,
        name = phaseNames[phaseIndex + 1],
        age = daysElapsed
    }
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
if not year or not month or not day then --if no valid date is provided, default to today's date
    print("No valid date provided. Defaulting to today's date.")
    local current_date = os.date("*t")
    year = tonumber(current_date.year)
    month = tonumber(current_date.month)
    day = tonumber(current_date.day)
    date = { year = year, month = month, day = day }
end
local currentPhase = getMoonPhase(date.year, date.month, date.day) --get the moon phase for the provided date

print("Current Phase: " .. currentPhase.name)
print("Cycle Progress: " .. string.format("%.2f%%", currentPhase.percent * 100))
print("Moon Age: " .. string.format("%.2f", currentPhase.age) .. " days")
