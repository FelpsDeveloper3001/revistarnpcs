# Script de Revistar NPCs Mortos

Este script permite que jogadores revistem NPCs mortos para encontrar itens valiosos usando ox_target e ox_lib, com sistema de áreas e tipos de PED específicos.

## Funcionalidades

- ✅ Opção "Revistar" aparece em NPCs mortos via ox_target
- ✅ Animação de agachado durante a revista
- ✅ Progressbar de 5 segundos usando ox_lib
- ✅ Sistema de itens configurável
- ✅ Cooldown entre revistas no mesmo NPC
- ✅ Notificações informativas
- ✅ Integração com sistemas de inventário
- ✅ **Itens persistentes para todos os jogadores**
- ✅ **NPCs desaparecem após 3 minutos após primeira revista**
- ✅ **Sistema de áreas com itens específicos**
- ✅ **Tipos de PED com loots únicos**
- ✅ **Inventário configurável (slots, peso, nome)**
- ✅ **Sistema de prioridade entre área e tipo de PED**

## Dependências

- ox_lib
- ox_target
- ox_inventory (opcional, para inventário)

## Instalação

1. Coloque o script na pasta `resources` do seu servidor
2. Adicione `ensure nome_do_script` no seu `server.cfg`
3. Configure os itens no arquivo `config.lua`
4. Integre com seu sistema de inventário no arquivo `server/main.lua`

## Configuração

### Itens Padrão

```lua
Config.Items = {
    {
        item = 'money',           -- Nome do item
        label = 'Dinheiro',       -- Nome exibido
        amount = {min = 10, max = 500}, -- Quantidade (min/max)
        chance = 70               -- Chance de encontrar (1-100)
    }
}
```

### Tipos de PED

```lua
Config.PedTypes = {
    ["police"] = {
        name = "Policial",
        models = {"s_m_y_cop_01", "s_m_y_cop_02"}, -- Modelos do PED
        items = {
            {
                item = 'badge',
                label = 'Distintivo',
                amount = {min = 1, max = 1},
                chance = 90
            }
        }
    }
}
```

### Áreas Específicas

```lua
Config.Areas = {
    {
        name = "Centro Rico",
        coords = {x = 150.0, y = -1050.0, z = 29.0},
        radius = 300.0, -- Raio em metros
        items = {
            {
                item = 'jewelry',
                label = 'Joias',
                amount = {min = 1, max = 3},
                chance = 60
            }
        }
    }
}
```

### Configurações Gerais

```lua
Config.SearchTime = 5000          -- Tempo da progressbar (ms)
Config.MaxItemsPerSearch = 3      -- Máximo de itens por busca
Config.Cooldown = 30000          -- Cooldown entre buscas (ms)
Config.NPCDisappearTime = 180000 -- Tempo para NPC desaparecer (3 min)

-- Inventário
Config.Inventory = {
    slots = 10,                   -- Número de slots
    maxWeight = 25000,           -- Peso máximo (gramas)
    label = "Corpo Revistado"     -- Nome do inventário
}

-- Tipos de PED
Config.PedTypes = {
    enabled = true,               -- Ativar sistema
    priority = "ped",            -- Prioridade: "ped" ou "area"
    fallbackToDefault = true,    -- Usar itens padrão como fallback
    showPedType = true          -- Mostrar notificação do tipo
}
```

## Sistema de Itens Persistentes

**Nova funcionalidade**: Quando um jogador revista um NPC pela primeira vez, os itens são definidos e ficam disponíveis para todos os outros jogadores que revistarem o mesmo NPC. Após 3 minutos da primeira revista, o NPC desaparece automaticamente.

### Como Funciona:

1. **Primeira Revista**: Jogador A revista NPC → Itens são definidos
2. **Outros Jogadores**: Jogador B, C, D... revistam o mesmo NPC → Encontram os mesmos itens
3. **Desaparecimento**: Após 3 minutos, NPC é removido automaticamente

## Sistema de Áreas

Diferentes regiões do mapa podem ter itens específicos:

- **Centro Rico**: Joias, relógios de ouro, dinheiro alto
- **Subúrbios Pobres**: Dinheiro baixo, documentos
- **Zona Industrial**: Ferramentas, chaves
- **Praia**: Óculos de sol, toalhas

## Sistema de Tipos de PED

Diferentes tipos de NPCs têm loots específicos:

- **Policiais**: Distintivo, algemas, rádio, arma
- **Médicos**: Kit médico, bandagem, estetoscópio
- **Taxistas**: Chaves do carro, recibos
- **Executivos**: iPhone, laptop, relógio, documentos
- **Construtores**: Ferramentas, capacete
- **Gangsters**: Armas, drogas, joias

## Integração com Inventário

Para integrar com ox_inventory, o script já está configurado automaticamente:

```lua
-- O script cria automaticamente um stash com:
-- - Nome configurável
-- - Slots configuráveis
-- - Peso máximo configurável
-- - Itens específicos da área/tipo de PED
```

## Comandos

### Cliente
- `/limparrevistas` - Limpa a lista de NPCs revistados (client-side)
- `/area` - Verifica área atual
- `/pedtype` - Verifica tipo de PED próximo

### Servidor (Apenas Admins)
- `/testarrevista` - Testa o sistema (requer permissão `revistar.admin`)
- `/limparnpcs` - Limpa todos os NPCs revistados (requer permissão `revistar.admin`)
- `/npcsrevistados` - Mostra NPCs revistados atualmente (requer permissão `revistar.admin`)

## Permissões ACE

O script usa sistema de permissões ACE para proteger comandos administrativos.

### Configuração de Permissões

Adicione estas linhas ao seu `server.cfg`:

```cfg
# Permissão para todos os comandos administrativos
add_ace group.admin revistar.admin allow
add_ace group.moderator revistar.admin allow
add_ace group.superadmin revistar.admin allow
```

### Permissão Única

- **`revistar.admin`** - Permite usar todos os comandos admin:
  - `/testarrevista`
  - `/limparnpcs`
  - `/npcsrevistados`

### Exemplo de Configuração

```cfg
# Para dar permissão a um jogador específico
add_ace identifier.steam:110000112345678 revistar.admin allow

# Para dar permissão a um grupo
add_ace group.admin revistar.admin allow
```

**Arquivo `permissions.cfg` incluído** com configuração simplificada.

## Como Usar

1. Encontre um NPC morto
2. Use o ox_target para selecionar "Revistar"
3. Aguarde a progressbar de 5 segundos
4. Receba os itens encontrados (específicos da área/tipo de PED)
5. Outros jogadores podem revistar o mesmo NPC e encontrar os mesmos itens
6. NPC desaparece automaticamente após 3 minutos

## Configurações Avançadas

### Performance
```lua
Config.Performance = {
    npcCheckInterval = 1000,      -- Intervalo para verificar NPCs (ms)
    cleanupInterval = 10000,      -- Intervalo para limpeza (ms)
    maxNPCsPerCheck = 50         -- Máximo NPCs por verificação
}
```

### Distâncias
```lua
Config.Distance = {
    searchRange = 5.0,           -- Distância para detectar NPCs
    interactionRange = 3.0,      -- Distância para interagir
    tooFarDistance = 3.0         -- Distância máxima para revistar
}
```

### Animações
```lua
Config.Animation = {
    dict = "amb@medic@standing@kneel@base",
    clip = "base",
    flag = 1,
    blendIn = 8.0,
    blendOut = -8.0
}
```

### Notificações
```lua
Config.Notifications = {
    enabled = true,              -- Ativar notificações
    position = "top-right",      -- Posição
    sound = true                -- Som
}
```

## Estrutura de Arquivos

```
├── fxmanifest.lua
├── config.lua
├── permissions.cfg
├── client/
│   └── main.lua
├── server/
│   └── main.lua
└── README.md
```

## Suporte

Para suporte ou dúvidas, entre em contato através do Discord ou GitHub.

## Changelog

### v1.0.0
- ✅ Sistema básico de revista
- ✅ Animação de agachado
- ✅ Progressbar com ox_lib
- ✅ Integração com ox_target

### v1.1.0
- ✅ Itens persistentes para todos os jogadores
- ✅ NPCs desaparecem após 3 minutos
- ✅ Sistema de inventário com ox_inventory

### v1.2.0
- ✅ Sistema de áreas com itens específicos
- ✅ Sistema de tipos de PED com loots únicos
- ✅ Configurações avançadas de performance
- ✅ Sistema de prioridade entre área e tipo de PED 