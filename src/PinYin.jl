module PinYin

export pinyin

# https://github.com/hotoo/pinyin/blob/master/src/data/dict-zi.ts
const DataFile = joinpath(@__DIR__, "..", "data", "dict-zi.ts")

function LoadPinyinData(DataFile)
    CharacterCode, CharacterPinyin = UInt32[], []
    for line in readlines(DataFile)
        if startswith(line, "dict")
            char, pinyin = match(Regex("^dict\\[(.*)\\].*\"(.*)\""), line).captures
            push!(CharacterCode, parse(UInt32, char))
            push!(CharacterPinyin, pinyin)
        end
    end
    return CharacterCode, CharacterPinyin
end

global CharacterCode, CharacterPinyin = LoadPinyinData(DataFile)

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
