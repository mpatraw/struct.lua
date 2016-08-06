
local struct = require("struct")

local vector = struct {
	x = 0,
	y = 2
}

local rect = struct {
	pos = vector(),
	siz = vector()
}

local what = struct {}

local r = rect()

r.pos.x = 5
print(r.pos.x)

for k, v in struct.pairs(r) do
	print(k, v, struct.type(v))
	for kk, vv in struct.pairs(v) do
		print(kk, vv, struct.type(vv))
	end
end
