-- Tabela para armazenar itens de cada NPC revistado
local npcItems = {}
local npcSearchTime = {}

-- Evento para dar itens ao jogador após revistar NPC
RegisterNetEvent('revistar:giveItems', function(npcId, foundItems)
    local source = source
    local player = GetPlayerName(source)
    local stashId = 'npc_' .. npcId
    
    if not foundItems or #foundItems == 0 then
        return
    end
    
    -- Se é a primeira vez que este NPC está sendo revistado, define os itens
    if not npcItems[npcId] then
        npcItems[npcId] = foundItems
        npcSearchTime[npcId] = os.time()
        
        -- Cria o stash no ox_inventory
        if GetResourceState('ox_inventory') == 'started' then
            exports.ox_inventory:RegisterStash(stashId, Config.Inventory.label, Config.Inventory.slots, Config.Inventory.maxWeight)
            
            -- Adiciona os itens ao stash
            for _, item in pairs(foundItems) do
                exports.ox_inventory:AddItem(stashId, item.item, item.amount)
            end
        end
        
        -- Agenda o NPC para desaparecer após o tempo configurado
        SetTimeout(Config.NPCDisappearTime, function()
            if npcItems[npcId] then
                npcItems[npcId] = nil
                npcSearchTime[npcId] = nil
                -- Notifica todos os clientes para remover o NPC
                TriggerClientEvent('revistar:removeNPC', -1, npcId)
            end
        end)
        
        print(string.format('[REVISTAR] Primeira revista no NPC %s por %s', npcId, player))
    end
    
    -- Abre o inventário do stash para o jogador
    if GetResourceState('ox_inventory') == 'started' then
        TriggerClientEvent('revistar:openStash', source, stashId)
    end
    
    -- Log da ação
    print(string.format('[REVISTAR] Jogador %s revistou NPC %s e abriu o inventário', player, npcId))
end)

-- Evento para verificar se NPC já foi revistado
RegisterNetEvent('revistar:checkNPC', function(npcId)
    local source = source
    
    if npcItems[npcId] then
        -- NPC já foi revistado, envia os itens existentes
        TriggerClientEvent('revistar:npcAlreadySearched', source, npcId, npcItems[npcId])
    else
        -- NPC ainda não foi revistado
        TriggerClientEvent('revistar:npcNotSearched', source, npcId)
    end
end)

-- Comando para testar o sistema (apenas para admins)
RegisterCommand('testarrevista', function(source, args)
    -- Verifica permissão ACE
    if not IsPlayerAceAllowed(source, 'revistar.admin') then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Sistema", "Você não tem permissão para usar este comando!"}
        })
        return
    end
    
    local player = GetPlayerName(source)
    
    -- Simula itens encontrados para teste
    local testItems = {
        {item = 'money', label = 'Dinheiro', amount = 100},
        {item = 'phone', label = 'Celular', amount = 1}
    }
    
    TriggerClientEvent('revistar:giveItems', source, testItems)
    
    print(string.format('[REVISTAR] Teste executado por %s', player))
end, false)

-- Comando para limpar todos os NPCs revistados (apenas para admins)
RegisterCommand('limparnpcs', function(source, args)
    -- Verifica permissão ACE
    if not IsPlayerAceAllowed(source, 'revistar.admin') then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Sistema", "Você não tem permissão para usar este comando!"}
        })
        return
    end
    
    local player = GetPlayerName(source)
    
    npcItems = {}
    npcSearchTime = {}
    
    -- Notifica todos os clientes para limpar a lista
    TriggerClientEvent('revistar:clearAllNPCs', -1)
    
    print(string.format('[REVISTAR] Todos os NPCs revistados foram limpos por %s', player))
end, false)

-- Comando para ver NPCs revistados (apenas para admins)
RegisterCommand('npcsrevistados', function(source, args)
    -- Verifica permissão ACE
    if not IsPlayerAceAllowed(source, 'revistar.admin') then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Sistema", "Você não tem permissão para usar este comando!"}
        })
        return
    end
    
    local player = GetPlayerName(source)
    
    print(string.format('[REVISTAR] NPCs revistados por %s:', player))
    for npcId, items in pairs(npcItems) do
        print(string.format('NPC %s: %d itens', npcId, #items))
    end
end, false) 