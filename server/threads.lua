CreateThread(function()
    while RS.Framework == nil do
        RS.Framework = Utils.Functions:GetFramework()
        Wait(350)
    end
end)
