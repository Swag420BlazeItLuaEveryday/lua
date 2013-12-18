-- **************************************************************
-- @class Slot
--
-- Contains information about an inventory slot
-- 
-- Keys: "id","item","qty"
-- Defaults: 0,Item.new(),0
--
-- **************************************************************

if not Item and shell then
	assert(shell.run("Item.class.lua"),"Class not found: Item.class.lua");
elseif not Item then
	assert(os.run(getfenv(),"Item.class.lua"),"Class not found: Item.class.lua");
end

Slot = {};
Slot.__index = Slot;

Slot.__eq = function(lhs,rhs)

	return lhs.id == rhs.id;
end

Slot.__tostring = function(obj)
	if obj.qty then
		return "Slot " .. tostring(obj.id) .. ": " .. tostring(obj.item) .. " x " .. tostring(obj.qty);
	else
		return "Slot " .. tostring(obj.id) .. " empty";
	end
end

function Slot.new(...)
	local args = {...};
	local class = {};
	setmetatable(class,Slot);

	local keys = {"id","item","qty"};
	local defaults = {0,Item.new(),0};

	for i = 1,math.min(#args,#keys) do
		class[keys[i]] = args[i];
	end
	for i = #args+1,#keys do
		class[keys[i]] = defaults[i];
	end

	return class;
end

function Slot:write(file)
	assert(file,"An invalid file handle was supplied");
	assert(file.write,"An invalid handle was supplied");
	file:write(self.id);
	self.item:write(file);
	file:write(self.qty);
end

function Slot.read(file)
	assert(file,"An invalid file handle was supplied");
	assert(file.read,"An invalid handle was supplied");
	
	local slot = Slot.new();

	slot.id = file.read("*number");
	slot.item = Item.read(file);
	slot.qty = file.read("*number");

	if slot.id == nil or slot.item == nil or slot.qty == nil then
		return nil;
	else
		return slot;
	end
end