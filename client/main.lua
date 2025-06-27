local searchedNPCs = {}
local isSearching = false
local npcEntities = {} -- Para rastrear entidades de NPC

-- Função para verificar se um NPC está morto
local function IsNPCDEAD(npc)
    return IsEntityDead(npc) and IsPedAPlayer(npc) == false
end

-- Função para detectar o tipo de PED
local function GetPedType(npc)
    if not Config.PedTypes.enabled then
        return nil
    end
    
    local pedModel = GetEntityModel(npc)
    local pedModelName = GetHashKey(pedModel)
    
    for pedType, pedData in pairs(Config.PedTypes) do
        if type(pedData) == "table" and pedData.models then
            for _, modelName in pairs(pedData.models) do
                if GetHashKey(modelName) == pedModelName then
                    return pedType, pedData
                end
            end
        end
    end
    
    return nil, nil
end

-- Função para detectar a área atual do jogador
local function GetCurrentArea()
    if not Config.Areas.enabled then
        return nil
    end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    for _, area in pairs(Config.SpecificAreas) do
        if area.coords and area.radius then -- Verifica se é uma área válida
            local areaCoords = vector3(area.coords.x, area.coords.y, area.coords.z)
            local distance = #(playerCoords - areaCoords)
            
            if distance <= area.radius then
                return area
            end
        end
    end
    
    return nil
end

-- Função para obter itens aleatórios baseado na chance
local function GetRandomItems(npc)
    local foundItems = {}
    local itemsFound = 0
    
    -- Detecta a área atual
    local currentArea = GetCurrentArea()
    local pedType, pedData = GetPedType(npc)
    
    -- Define quais itens usar baseado na prioridade
    local itemsToUse = Config.Items -- Itens padrão como fallback
    
    if Config.PedTypes.priority == "ped" and pedData then
        -- Prioridade para tipo de PED
        itemsToUse = pedData.items
    elseif currentArea and currentArea.items then
        -- Prioridade para área
        itemsToUse = currentArea.items
    end
    
    -- Se não encontrou itens específicos e fallback está ativado
    if not itemsToUse and Config.PedTypes.fallbackToDefault then
        itemsToUse = Config.Items
    end
    
    -- Mostra notificação do tipo de PED se ativado
    if Config.PedTypes.showPedType and pedData then
        lib.notify({
            title = 'Tipo de PED',
            description = 'Você está revistando um: ' .. pedData.name,
            type = 'info',
            duration = 2000
        })
    end
    
    for _, itemData in pairs(itemsToUse) do
        if itemsFound >= Config.MaxItemsPerSearch then
            break
        end
        
        if math.random(1, 100) <= itemData.chance then
            local amount = math.random(itemData.amount.min, itemData.amount.max)
            table.insert(foundItems, {
                item = itemData.item,
                label = itemData.label,
                amount = amount
            })
            itemsFound = itemsFound + 1
        end
    end
    
    return foundItems
end

-- Função para mostrar notificação de área detectada
local function ShowAreaNotification()
    local currentArea = GetCurrentArea()
    if currentArea and Config.Notifications.enabled then
        lib.notify({
            title = 'Área Especial',
            description = 'Você está em: ' .. currentArea.name,
            type = 'info',
            duration = Config.Areas.notificationDuration
        })
    end
end

-- Função para fazer a animação de agachado
local function PlayCrouchAnimation()
    local ped = PlayerPedId()
    
    -- Carrega a animação
    RequestAnimDict(Config.Animation.dict)
    while not HasAnimDictLoaded(Config.Animation.dict) do
        Wait(10)
    end
    
    -- Executa a animação
    TaskPlayAnim(ped, Config.Animation.dict, Config.Animation.clip, Config.Animation.blendIn, Config.Animation.blendOut, -1, Config.Animation.flag, 0, false, false, false)
end

-- Função para parar a animação
local function StopCrouchAnimation()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
end

-- Função para obter ID único do NPC
local function GetNPCId(npc)
    local coords = GetEntityCoords(npc)
    return string.format("%.2f_%.2f_%.2f", coords.x, coords.y, coords.z)
end

-- Função principal para revistar NPC
local function SearchNPC(npc)
    if isSearching then
        return
    end
    
    local npcCoords = GetEntityCoords(npc)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - npcCoords)
    
    if distance > Config.Distance.tooFarDistance then
        lib.notify({
            title = 'Erro',
            description = Config.Messages.too_far,
            type = 'error'
        })
        return
    end
    
    local npcId = GetNPCId(npc)
    
    -- Verifica se já foi revistado recentemente (apenas para o mesmo jogador)
    if searchedNPCs[npc] and (GetGameTimer() - searchedNPCs[npc]) < Config.Cooldown then
        lib.notify({
            title = 'Aviso',
            description = Config.Messages.already_searched,
            type = 'warning'
        })
        return
    end
    
    isSearching = true
    
    -- Inicia a animação de agachado
    PlayCrouchAnimation()
    
    -- Inicia a progressbar
    if lib.progressBar({
        duration = Config.SearchTime,
        label = Config.Messages.searching,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    }) then
        -- Progressbar completada com sucesso
        searchedNPCs[npc] = GetGameTimer()
        
        -- Para a animação após a revista
        StopCrouchAnimation()
        
        -- Verifica com o servidor se o NPC já foi revistado
        TriggerServerEvent('revistar:checkNPC', npcId)
    else
        -- Progressbar cancelada
        lib.notify({
            title = 'Cancelado',
            description = Config.Messages.search_cancelled,
            type = 'error'
        })
        StopCrouchAnimation()
    end
    
    isSearching = false
end

-- Evento para quando NPC já foi revistado (primeira vez)
RegisterNetEvent('revistar:npcNotSearched', function(npcId)
    -- Encontra o NPC pelo ID
    local npc = nil
    for entity, _ in pairs(npcEntities) do
        if GetNPCId(entity) == npcId then
            npc = entity
            break
        end
    end
    
    local foundItems = GetRandomItems(npc)
    
    if #foundItems > 0 then
        -- Envia os itens encontrados para o servidor
        TriggerServerEvent('revistar:giveItems', npcId, foundItems)
        
        lib.notify({
            title = 'Sucesso',
            description = Config.Messages.found_items,
            type = 'success'
        })
    else
        lib.notify({
            title = 'Informação',
            description = Config.Messages.nothing_found,
            type = 'info'
        })
    end
end)

-- Evento para quando NPC já foi revistado (outros jogadores)
RegisterNetEvent('revistar:npcAlreadySearched', function(npcId, items)
    if #items > 0 then
        -- Envia os itens existentes para o servidor
        TriggerServerEvent('revistar:giveItems', npcId, items)
        
        lib.notify({
            title = 'Sucesso',
            description = Config.Messages.found_items,
            type = 'success'
        })
    else
        lib.notify({
            title = 'Informação',
            description = Config.Messages.nothing_found,
            type = 'info'
        })
    end
end)

-- Evento para abrir o stash do ox_inventory
RegisterNetEvent('revistar:openStash', function(stashId)
    if GetResourceState('ox_inventory') == 'started' then
        exports.ox_inventory:openInventory('stash', stashId)
    end
end)

-- Evento para remover NPC após 3 minutos
RegisterNetEvent('revistar:removeNPC', function(npcId)
    -- Remove o NPC da lista de revistados
    for npc, _ in pairs(searchedNPCs) do
        if GetNPCId(npc) == npcId then
            searchedNPCs[npc] = nil
            break
        end
    end
    
    -- Remove o NPC do ox_target
    for npc, _ in pairs(npcEntities) do
        if GetNPCId(npc) == npcId then
            exports.ox_target:removeLocalEntity(npc, 'search_npc')
            npcEntities[npc] = nil
            break
        end
    end
end)

-- Evento para limpar todos os NPCs
RegisterNetEvent('revistar:clearAllNPCs', function()
    searchedNPCs = {}
    npcEntities = {}
    
    lib.notify({
        title = 'Sucesso',
        description = 'Todos os NPCs revistados foram limpos',
        type = 'success'
    })
end)

-- Thread para detectar entrada em áreas especiais
CreateThread(function()
    local lastArea = nil
    
    while true do
        Wait(Config.Areas.checkInterval)
        
        local currentArea = GetCurrentArea()
        
        -- Se entrou em uma nova área
        if currentArea and currentArea.name ~= lastArea then
            ShowAreaNotification()
            lastArea = currentArea.name
        elseif not currentArea then
            lastArea = nil
        end
    end
end)

-- Thread para adicionar opção de revistar em NPCs mortos
CreateThread(function()
    while true do
        Wait(Config.Performance.npcCheckInterval)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- Procura por NPCs próximos
        local npcs = GetGamePool('CPed')
        local npcCount = 0
        
        for _, npc in pairs(npcs) do
            if npcCount >= Config.Performance.maxNPCsPerCheck then
                break
            end
            
            if npc ~= playerPed and IsNPCDEAD(npc) then
                local npcCoords = GetEntityCoords(npc)
                local distance = #(playerCoords - npcCoords)
                
                if distance <= Config.Distance.searchRange and not npcEntities[npc] then
                    -- Adiciona a opção de revistar usando ox_target
                    exports.ox_target:addLocalEntity(npc, {
                        {
                            name = 'search_npc',
                            icon = 'fas fa-search',
                            label = 'Revistar',
                            distance = Config.Distance.interactionRange,
                            onSelect = function()
                                SearchNPC(npc)
                            end,
                            canInteract = function()
                                return not isSearching
                            end
                        }
                    })
                    
                    npcEntities[npc] = true
                end
                npcCount = npcCount + 1
            end
        end
    end
end)

-- Evento para limpar NPCs revistados quando eles desaparecem
CreateThread(function()
    while true do
        Wait(Config.Performance.cleanupInterval)
        
        for npc, _ in pairs(searchedNPCs) do
            if not DoesEntityExist(npc) then
                searchedNPCs[npc] = nil
                npcEntities[npc] = nil
            end
        end
    end
end)

-- Comando para limpar NPCs revistados (útil para debug)
RegisterCommand('limparrevistas', function()
    searchedNPCs = {}
    npcEntities = {}
    lib.notify({
        title = 'Sucesso',
        description = 'Lista de NPCs revistados limpa',
        type = 'success'
    })
end, false)

-- Comando para verificar área atual
RegisterCommand('area', function()
    local currentArea = GetCurrentArea()
    if currentArea then
        lib.notify({
            title = 'Área Atual',
            description = 'Você está em: ' .. currentArea.name,
            type = 'info'
        })
        print(string.format('[REVISTAR] Área: %s, Coordenadas: %.2f, %.2f, %.2f', 
            currentArea.name, currentArea.coords.x, currentArea.coords.y, currentArea.coords.z))
    else
        lib.notify({
            title = 'Área Atual',
            description = 'Você não está em uma área especial',
            type = 'info'
        })
    end
end, false)

-- Comando para verificar tipo de PED próximo
RegisterCommand('pedtype', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Procura por NPCs próximos
    local npcs = GetGamePool('CPed')
    local closestNPC = nil
    local closestDistance = 999.0
    
    for _, npc in pairs(npcs) do
        if npc ~= playerPed and IsNPCDEAD(npc) then
            local npcCoords = GetEntityCoords(npc)
            local distance = #(playerCoords - npcCoords)
            
            if distance < closestDistance and distance <= 5.0 then
                closestDistance = distance
                closestNPC = npc
            end
        end
    end
    
    if closestNPC then
        local pedType, pedData = GetPedType(closestNPC)
        if pedData then
            lib.notify({
                title = 'Tipo de PED',
                description = 'NPC próximo: ' .. pedData.name,
                type = 'info'
            })
            print(string.format('[REVISTAR] Tipo de PED: %s, Modelo: %s', pedData.name, GetEntityModel(closestNPC)))
        else
            lib.notify({
                title = 'Tipo de PED',
                description = 'NPC próximo: Civil',
                type = 'info'
            })
        end
    else
        lib.notify({
            title = 'Tipo de PED',
            description = 'Nenhum NPC morto próximo',
            type = 'info'
        })
    end
end, false) 