----------------------------------------
--- Discord Whitelist, Made by FAXES ---
----------------------------------------

--- Config ---
roleNeeded = "GTA" -- The role nickname needed to pass the whitelist
notWhitelisted = "Vous n'êtes pas Whitelisté, go : https://discord.gg/Wm6neGW ." -- Message displayed when they are not whitelist with the role
noDiscord = "Discord doit être ouvert !" -- Message displayed when discord is not found


--- Code ---

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local src = source
    deferrals.defer()
    deferrals.update("Checking Permissions")

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end

    if identifierDiscord then
        if exports.discord_perms:IsRolePresent(src, roleNeeded) then
            deferrals.done()
        else
            deferrals.done(notWhitelisted)
        end
    else
        deferrals.done(noDiscord)
    end
end)