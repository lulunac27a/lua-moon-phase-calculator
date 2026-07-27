package.path = package.path .. ";../?.lua;./?.lua"
local moon = require("moon")

local function assert_equal(a, b, msg)
    if a ~= b then error(string.format("Assertion failed: %s (got %s, expected %s)", msg, tostring(a), tostring(b))) end
end

-- Test: reference new moon date should be New Moon
local r = moon.getMoonPhase(2000, 1, 6)
assert_equal(r.name, "New Moon", "2000-01-06 should be New Moon")

-- Test: today's call returns a table with required fields
local t = os.date("*t")
local today = moon.getMoonPhase(t.year, t.month, t.day)
assert(type(today.name) == "string", "name should be string")
assert(type(today.age) == "number", "age should be number")
assert(type(today.illumination) == "number", "illumination should be number")

print("All tests passed")
