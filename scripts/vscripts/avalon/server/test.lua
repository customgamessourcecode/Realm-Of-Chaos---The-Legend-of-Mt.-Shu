
--[[
AvalonBuffer规则
[Key|Value标识][类型][长度][值]

Key标识 	0x01
Value标识	0x02

类型
TYPE_STRING 	0x03
TYPE_INT 		0x04
TYPE_FLOAT 		0x05
TYPE_BOOLEAN 	0x06
TYPE_OBJECT 	0x07
]]

local AvalonBuffer = {
	START_KEY 		= 0x01,
	START_VALUE 	= 0x02,
	TYPE_STRING 	= 0x03,
	TYPE_INT 		= 0x04,
	TYPE_FLOAT 		= 0x05,
	TYPE_BOOLEAN 	= 0x06,
	TYPE_OBJECT 	= 0x07,
}
local strchar = string.char

function AvalonBuffer:Start()
	return strchar(self.TYPE_START)
end

function AvalonBuffer:End()
	return strchar(self.TYPE_END)
end

function AvalonBuffer:String(str)
	return self:Start()..strchar(self.TYPE_STRING)..str..self:End()
end

function AvalonBuffer:Int(number)
	return self:Start()..strchar(self.TYPE_INT)..tostring(math.floor(number))..self:End()
end

function AvalonBuffer:Float(number)
	return self:Start()..strchar(self.TYPE_FLOAT)..tostring(number)..self:End()
end

function AvalonBuffer:Object(obj)
	local str = ''
	for k,v in pairs(obj) do
		str = str .. self:Key(k) .. self:Value(v)
	end
	return self:Start()..strchar(self.TYPE_OBJECT)..str..self:End()
end

function AvalonBuffer:Key(key)
	if type(key) ~= "string" then
		error("[AvalonBuffer] Key(key) the key is not string")
	end
	return strchar(self.TYPE_STRING)..key
end

function AvalonBuffer:Value(value)
	if type(value) == "string" then
		return self:String(value)
	elseif type(value) == "number" then
		if string.find(tostring(value),'%.') == nil then
			return self:Int(value)
		else
			return self:Float(value)
		end
	elseif type(value) == "table" then
		return self:Object(value)
	end
	error("[AvalonBuffer] Value(value) the value invalid")
end

function AvalonBuffer:Encode(t)
	return self:Value(t)
end

function AvalonBuffer:Parse(bytes)
	local isStart = false
	local isKey = true
	local t = {}
	local _type = -1
	local key = ''
	local value = ''

	for i,byte in ipairs(bytes) do
		repeat
			if isStart == false and byte == self.TYPE_START then
				isStart = true
				break
			end
			if byte == self.TYPE_END then
				if isKey then
					isKey = false
				else
					if _type == self.TYPE_STRING then
						t[key] = tostring(value)
					elseif _type == self.TYPE_INT then
						t[key] = math.ceil(tonumber(value))
					elseif _type == self.TYPE_FLOAT then
						t[key] = tonumber(value)
					end
				end
				_type = -1
				isStart = false
				break
			end
			if _type == -1 then
				if byte == self.TYPE_STRING then
					_type = self.TYPE_STRING
					break
				elseif byte == self.TYPE_INT then
					_type = self.TYPE_INT
					break
				elseif byte == self.TYPE_FLOAT then
					_type = self.TYPE_FLOAT
					break
				end
			end

			if isKey then
				key = key .. strchar(byte)
			else
				value = value .. strchar(byte)
			end

		until true
	end

	return t
end

function AvalonBuffer:Decode(str)
	local bytes = string.byte(str)
end