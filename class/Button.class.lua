-- **************************************************************
-- @class Button
--
-- A GUI button class, requires advanced computer and turtles
-- 
-- Keys: "x","y","text","width","height","bgColour","txtColour","func"
-- Defaults: 1,1,"Ok",2,1,colours.black,colours.white,false
--
-- **************************************************************

Button = {};
Button.__index = Button;

Button.__concat = function(lhs, rhs)
	return lhs .. rhs;
end

Button.__eq = function(lhs,rhs)
	return lhs == rhs;
end

Button.__call = function(obj,...)
	local args = {...};
	if type(obj.func) == "function" then
		return obj.func(unpack(args));
	elseif type(obj.func) == "table" then
		local results = {};
		for i = 1,#obj.func do
			results[#results+1] = obj.func[i](unpack(args));
		end
		return results;
	else
		return nil;
	end
end

function Button.new(...)
	local args = {...};
	local class = {};
	setmetatable(class,Button);

	local keys = {"x","y","text","width","height","bgColour","txtColour","func"};
	local defaults = {1,1,"Ok",2,1,colours.black,colours.white,false};

	for i = 1,math.min(#args,#keys) do
		class[keys[i]] = args[i];
	end
	for i = #args+1,#keys do
		class[keys[i]] = defaults[i];
	end

	if #args == 3 then
		class.width = string.len(class.text);
	end

	return class;
end

function Button:draw(...)
	local x,y = term.getCursorPos();
	local sx,sy = term.getSize();
	term.setCursorPos(
		math.max(1,self.x),
		math.max(1,self.y)
	);
	term.setBackgroundColour(self.bgColour);
	term.setTextColour(self.txtColour);
	term.write(self.text:sub(1,math.min(self.text:len(), sx - self.x - self.text:len())));
	term.setCursorPos(x,y);
end

function Button:isSelected(x,y)
	if x >= self.x and x <= self.x+self.width and y >= self.y and y <= self.y+self.height then
		return true;
	else
		return false;
	end
end
