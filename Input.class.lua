-- **************************************************************
-- @class Input
--
-- An input box class for cc GUIs
-- 
-- Keys: "x","y","width","colour","bgColour","cursorPos","text"
-- Defaults: 1,1,5,colours.white,colours.black,0,""
--
-- **************************************************************

if not Rectangle then
	shell.run("Rectangle.class.lua");
end

Input = {};
Input.__index = Input;

function Input.new(...)
	local args = {...};
	local class = {};
	setmetatable(class,Input);

	local keys = {"x","y","width","colour","bgColour","selected","cursorPos","text"};
	local defaults = {1,1,5,colours.white,colours.black,false,0,""};

	for i = 1,math.min(#args,#keys) do
		class[keys[i]] = args[i];
	end
	for i = #args+1,#keys do
		class[keys[i]] = defaults[i];
	end

	return class;
end

function Input:draw(...)
	local args = {...};
	local x,y = term.getCursorPos();

	Rectangle.new(self.x,self.y,self.width,0,self.bgColour):draw(unpack(args));
	term.setCursorPos(self.x,self.y);
	term.setTextColour(self.colour);
	term.write(self.text);

	if self.selected then
		term.setCursorPos(self.x+self.cursorPos,self.y);
		term.setCursorBlink(true);
	else
		term.setCursorBlink(false);
		term.setCursorPos(x,y);
	end
end

function Input:char(char)
	self.text = self.text .. char;
	local x,y = term.getCursorPos();
	term.setCursorPos(self.x+self.cursorPos,self.y);
	term.write(tostring(char));
	self.cursorPos = self.cursorPos + 1;

	if self.selected then
		term.setCursorPos(self.x+self.cursorPos,self.y);
		term.setCursorBlink(true);
	else
		term.setCursorBlink(false);
		term.setCursorPos(x,y);
	end	
end
