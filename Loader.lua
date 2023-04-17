
repeat
    task.wait()
until game:IsLoaded()


getgenv().games = {
    2489678543,
}

for i,v in pairs(getgenv().games) do
    if v == game.PlaceId then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FearLLC/FearV1/main/Games/"..game.PlaceId..".lua", true))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FearLLC/FearV1/main/Universal.lua", true))()
    end
end
