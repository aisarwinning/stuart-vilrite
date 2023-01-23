return function (input, divider)
        if divider == nil then
            divider = "%s"
        end
  
        local split_table = {}

        for str in string.gmatch(input, "([^" ..divider.. "]+)") do
                table.insert(split_table, str)
        end
  
        return split_table
end