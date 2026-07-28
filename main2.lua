-- CLI wrapper using moon.lua
package.path = package.path .. ";./?.lua"
local moon = require("moon") --moon file for moon phase calculations

local function usage()       --usage instructions for the command line interface
    print("Moon Phase Calculator CLI")
    print("Options:")
    print("  --date YYYY-MM-DD   Specify the date for moon phase calculation")
    print("  --json              Output result in JSON format")
    print("  --verbose           Show additional information")
    print("  --help, -h          Show this help message")
    print("Usage: lua main2.lua [--date YYYY-MM-DD] [--json] [--verbose]")
    print("Examples:")
    print("  lua main2.lua --date 2026-07-27")
    print("  lua main2.lua 2026 7 27 --json")
end

local args = {}
for i = 1, #arg do args[i] = arg[i] end

local opts = { json = false, verbose = false } --table to hold command line options
local year, month, day                         --variables to hold the date for moon phase calculation

local i = 1
while i <= #args do
    local a = args[i]                                      --command line arguments
    if a == "--help" or a == "-h" then
        usage(); os.exit(0)                                --help option
    elseif a == "--json" then
        opts.json = true                                   --json output option
    elseif a == "--verbose" then
        opts.verbose = true                                --verbose output option
    elseif a == "--date" then                              --date option
        local v = args[i + 1]
        if not v then
            print("--date requires YYYY-MM-DD"); os.exit(1)
        end
        local y, m, d = v:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
        if not y then
            print("Invalid date format"); os.exit(1)
        end
        year = tonumber(y); month = tonumber(m); day = tonumber(d)
        i = i + 1
    else
        -- positional date: YYYY MM DD
        if not year and tonumber(a) and #args >= i + 2 then
            year = tonumber(a)
            month = tonumber(args[i + 1])
            day = tonumber(args[i + 2])
            i = i + 2
        elseif a:match("^%d%d%d%d%-%d%d%-%d%d$") and not year then
            local y, m, d = a:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
            year = tonumber(y); month = tonumber(m); day = tonumber(d)
        end
    end
    i = i + 1
end

if not year or not month or not day then
    local today = os.date("*t")
    year = year or today.year
    month = month or today.month
    day = day or today.day
    if opts.verbose then print(string.format("Using date: %04d-%02d-%02d", year, month, day)) end
end

local result = moon.getMoonPhase(year, month, day)

local function to_json(t)
    return string.format('{"date":"%04d-%02d-%02d","phase":"%s","age":%.2f,"illumination":%d,"percent":%.4f}',
        year, month, day, result.name, result.age, result.illumination, result.percent)
end

if opts.json then
    print(to_json(result))
else
    -- Match main.lua output
    print("Current Phase: " .. result.name)
    print("Cycle Progress: " .. string.format("%.2f%%", result.percent * 100))
    print("Moon Age: " .. string.format("%.2f", result.age) .. " days")
end
