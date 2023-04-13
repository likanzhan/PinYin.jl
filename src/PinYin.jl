module PinYin

export pinyin

# ?
const DataFile1 = joinpath(@__DIR__, "..", "data", "Mandarin1.dat")

# https://github.com/lxyu/pinyin/blob/master/pinyin/Mandarin.dat
const DataFile2 = joinpath(@__DIR__, "..", "data", "Mandarin2.dat")

function LoadPinyinData(DataFile)
	CharacterCode, CharacterPinyin = UInt32[], []
	for line in readlines(DataFile)
		char, pinyin = split(line, "\t")
		push!(CharacterCode, parse(UInt32, "0x" * char))
		push!(CharacterPinyin, pinyin)
	end
	return CharacterCode, CharacterPinyin
end

global CharacterCode, CharacterPinyin = LoadPinyinData(DataFile2)

"""
    pinyin(str::AbstractChar)
    pinyin(str::AbstractString; dlm = ", ")
    pinyin(str::AbstractArray; dlm = ", ")

### Example
```julia
str = ["春天秋月" "动手"; "你好" "他好"]
pinyin(str)
```
"""
function pinyin(str::AbstractChar)
	index = findall(x -> x == codepoint(str), CharacterCode)
	if !isempty(index)
		res = CharacterPinyin[index[]]
		return replace(res, "," => "/")
	else
		return str
	end
end

function pinyin(str::AbstractString; dlm = ", ")
	s = ""
	for id in eachindex(str)
		if id != lastindex(str)
			s *= pinyin(str[id]) * dlm
		else
			s *= pinyin(str[id])
		end
	end
	return s
end

function pinyin(str::AbstractArray; dlm = ", ")
	res = similar(str)
	for (idx, val) in enumerate(str)
		res[idx] = pinyin(val; dlm = dlm)
	end
	return res
end

end # module
