
if not Slot and shell then
	assert(shell.run("Slot.class.lua"),"Class not found: Slot.class.lua");
elseif not Slot then
	assert(os.run(getfenv(),"Slot.class.lua"),"Class not found: Slot.class.lua");
end

Inventory = {};
Inventory.__index = Inventory;

function Inventory.new(...)
	local args = {...};
	local inventory = {};
	setmetatable(inventory,Inventory);

	local keys = {"size","slots"};
	local defaults = {0,{}};

	for i = 1,math.min(#args,#keys) do
		inventory[keys[i]] = args[i];
	end
	for i = #args+1,#keys do
		inventory[keys[i]] = defaults[i];
	end

	if #inventory.slots == 0 then
		for i = 1,inventory.size do
			inventory.slots[i] = Slot.new(i);
		end
	end

	return inventory;
end

function Inventory:find(item)
	local key = nil;
	local slots = {};

	if type(item) == "number" then
		key = "id";
	elseif type(item) == "string" then
		key = "name";
	end

	for i = 1,self.size do
		if key then
			if self.slots[i].item[key] == item and self.slots[i].qty > 0 then
				slots[#slots+1] = i;
			end 
		else
			if self.slots[i].item == item and self.slots[i].qty > 0 then
				slots[#slots+1] = i;
			end
		end
	end

	return slots;
end

function Inventory:ids()
	local idList = {};

	for i = 1,self.size do
		if self.slots[i].qty > 0 then
			idList[self.slots[i].item.id] = true;
		end
	end

	local newList = {};
	for key,_ in pairs(idList) do
		newList[#newList+1] = key;
	end
	return newList;
end

function Inventory:quantity(item)
	local slots = self:find(item);
	local quantity = 0;

	for i = 1,#slots do
		quantity = quantity + self.slots[slots[i]].qty;
	end
	return quantity;
end

function Inventory:write(file)
	assert(file,"An invalid file handle was supplied");
	assert(file.write,"An invalid handle was supplied");
	file:write(self.size);
	for i = 1,self.size do
		self.slots[i]:write(file);
	end
end

function Inventory.read(file)
	assert(file,"An invalid file handle was supplied");
	assert(file.read,"An invalid handle was supplied");

	local size = file.read("*number");
	if size == nil then
		return nil;
	end
	local inventory = Inventory.new(size);

	for i = 1,size do
		inventory.slots[i] = Slot.read(file);
	end

	return inventory;
end