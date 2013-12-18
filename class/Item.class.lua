-- **************************************************************
-- @class Item
--
-- A class for containing information about an item
-- 
-- Keys: "id","name","dmg"
-- Defaults: 0,"unknown",0
--
-- **************************************************************

Item = {};
Item.__index = Item;

Item.__eq = function(lhs,rhs)

	return lhs.id == rhs.id;
end

Item.__tostring = function(obj)
	if obj.dmg > 0 then
		return obj.name .. " [" .. tostring(obj.id) .. ":" .. tostring(obj.dmg) .. "]";
	else
		return obj.name .. " [" .. tostring(obj.id) .. "]";
	end
end

Item.__metatable = true;

function Item.new(...)
	local args = {...};
	local class = {};
	setmetatable(class,Item);

	local keys = {"id","name","dmg"};
	local defaults = {0,"unknown",0};

	for i = 1,math.min(#args,#keys) do
		class[keys[i]] = args[i];
	end
	for i = #args+1,#keys do
		class[keys[i]] = defaults[i];
	end

	return class;
end

function Item:write(file)
	assert(file,"An invalid file handle was supplied");
	assert(file.write,"An invalid handle was supplied");
	file:write(self.id);
	file:write(#self.name);
	for i = 1,#self.name do
		file:write(self.name:byte(i));
	end
	file:write(self.dmg);
end

function Item.read(file)
	assert(file,"An invalid file handle was supplied");
	assert(file.read,"An invalid handle was supplied");
	local item = Item.new();

	item.id = file.read("*number");
	local size = file.read("*number");
	local chars = {};
	for i = 1,size do
		chars[#chars+1] = file.read();
	end
	item.name = string.char(unpack(chars));
	item.dmg = file.read("*number");

	if item.id == nil or item.name == nil or item.dmg == nil then
		return nil;
	else
		return item;
	end
end