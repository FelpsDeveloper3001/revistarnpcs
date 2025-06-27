Config = {}

-- Itens que podem ser encontrados ao revistar NPCs mortos (itens padrão)
Config.Items = {
    -- Dinheiro (chance de 70%)
    {
        item = 'money',
        label = 'Dinheiro',
        amount = {min = 10, max = 500},
        chance = 70
    },
    -- Cartão de crédito (chance de 30%)
    -- Celular (chance de 40%)
    {
        item = 'phone',
        label = 'Celular',
        amount = {min = 1, max = 1},
        chance = 40
    }
}

-- Itens específicos por tipo de PED
Config.PedTypes = {
    -- Policiais
    ["police"] = {
        name = "Policial",
        models = {
            "s_m_y_cop_01", "s_m_y_cop_02", "s_m_y_cop_03", "s_f_y_cop_01", "s_f_y_cop_02", "s_f_y_cop_03",
            "s_m_y_sheriff_01", "s_m_y_sheriff_02", "s_f_y_sheriff_01", "s_m_y_swat_01", "s_m_y_swat_02"
        },
        items = {
            {
                item = 'money',
                label = 'Dinheiro',
                amount = {min = 50, max = 300},
                chance = 60
            },
            {
                item = 'handcuffs',
                label = 'Algemas',
                amount = {min = 1, max = 1},
                chance = 70
            },
            {
                item = 'radio',
                label = 'Rádio',
                amount = {min = 1, max = 1},
                chance = 80
            },
            {
                item = 'weapon_pistol',
                label = 'Arma',
                amount = {min = 1, max = 1},
                chance = 30
            },
            {
                item = 'phone',
                label = 'Celular',
                amount = {min = 1, max = 1},
                chance = 50
            }
        }
    },
    
    -- Médicos/Paramedicos
    ["medic"] = {
        name = "Médico",
        models = {
            "s_m_m_doctor_01", "s_f_m_fembarber_01", "s_m_m_chemsec_01", "s_m_m_chemwork_01",
            "s_m_m_gaffer_01", "s_m_m_gentransport_01", "s_m_m_lathandy_01", "s_m_m_lifeinvad_01"
        },
        items = {
            {
                item = 'money',
                label = 'Dinheiro',
                amount = {min = 30, max = 200},
                chance = 70
            },
            {
                item = 'bandage',
                label = 'Bandagem',
                amount = {min = 1, max = 3},
                chance = 90
            },
            {
                item = 'phone',
                label = 'Celular',
                amount = {min = 1, max = 1},
                chance = 60
            }
        }
    },
    
    -- Taxistas
    ["taxi"] = {
        name = "Taxista",
        models = {
            "s_m_y_taxidriver_01", "s_m_m_trucker_01", "s_m_y_trucker_01", "s_m_m_gentransport_01"
        },
        items = {
            {
                item = 'money',
                label = 'Dinheiro',
                amount = {min = 20, max = 150},
                chance = 85
            },
            {
                item = 'phone',
                label = 'Celular',
                amount = {min = 1, max = 1},
                chance = 70
            }
        }
    },
    
    -- Empresários/Executivos
    ["business"] = {
        name = "Executivo",
        models = {
            "s_m_m_business_01", "s_m_m_business_02", "s_f_m_business_01", "s_f_m_business_02",
            "s_m_m_highsec_01", "s_m_m_highsec_02", "s_m_m_lawyer_01", "s_f_m_lawyer_01"
        },
        items = {
            {
                item = 'money',
                label = 'Dinheiro',
                amount = {min = 100, max = 1000},
                chance = 80
            },
            {
                item = 'phone',
                label = 'iPhone',
                amount = {min = 1, max = 1},
                chance = 90
            }
        }
    },
    
    -- Trabalhadores da construção
    ["construction"] = {
        name = "Construtor",
        models = {
            "s_m_y_construct_01", "s_m_y_construct_02", "s_m_m_gentransport_01", "s_m_m_lathandy_01"
        },
        items = {
            {
                item = 'money',
                label = 'Dinheiro',
                amount = {min = 15, max = 100},
                chance = 75
            },
            {
                item = 'phone',
                label = 'Celular',
                amount = {min = 1, max = 1},
                chance = 40
            }
        }
    },
    
    -- Gangsters/Criminosos
    ["gangster"] = {
        name = "Gangster",
        models = {
            "g_m_y_ballasout_01", "g_m_y_ballasout_02", "g_m_y_ballasout_03", "g_m_y_famca_01",
            "g_m_y_famca_02", "g_m_y_famdnf_01", "g_m_y_famdnf_02", "g_m_y_famfor_01",
            "g_m_y_famfor_02", "g_m_y_famfor_03", "g_m_y_famfor_04", "g_m_y_famfor_05"
        },
        items = {
            {
                item = 'money',
                label = 'Dinheiro',
                amount = {min = 50, max = 800},
                chance = 90
            },
            {
                item = 'weapon_pistol',
                label = 'Arma',
                amount = {min = 1, max = 1},
                chance = 40
            },
            {
                item = 'phone',
                label = 'Celular',
                amount = {min = 1, max = 1},
                chance = 60
            }
        }
    }
}

-- Áreas específicas com itens diferentes
Config.SpecificAreas = {
    -- Área rica (centro da cidade)
    {
        name = "Centro Rico",
        coords = {x = 150.0, y = -1050.0, z = 29.0}, -- Coordenadas do centro
        radius = 300.0, -- Raio em metros
        items = {
            {
                item = 'money',
                label = 'Dinheiro',
                amount = {min = 100, max = 2000},
                chance = 80
            },
            {
                item = 'phone',
                label = 'iPhone',
                amount = {min = 1, max = 1},
                chance = 70
            }
        }
    },
    
    -- Área pobre (subúrbios)
    {
        name = "Subúrbios Pobres",
        coords = {x = -1200.0, y = -1500.0, z = 4.0}, -- Coordenadas dos subúrbios
        radius = 300.0,
        items = {
            {
                item = 'money',
                label = 'Dinheiro',
                amount = {min = 5, max = 100},
                chance = 90
            },
            {
                item = 'phone',
                label = 'Celular Velho',
                amount = {min = 1, max = 1},
                chance = 20
            }
        }
    },
    
    -- Área industrial
    {
        name = "Zona Industrial",
        coords = {x = 800.0, y = -2000.0, z = 29.0}, -- Coordenadas da zona industrial
        radius = 300.0,
        items = {
            {
                item = 'money',
                label = 'Dinheiro',
                amount = {min = 20, max = 300},
                chance = 60
            },
            {
                item = 'phone',
                label = 'Celular',
                amount = {min = 1, max = 1},
                chance = 30
            }
        }
    },
    
    -- Área de praia
    {
        name = "Praia",
        coords = {x = -1500.0, y = -1000.0, z = 6.0}, -- Coordenadas da praia
        radius = 300.0,
        items = {
            {
                item = 'money',
                label = 'Dinheiro',
                amount = {min = 15, max = 400},
                chance = 75
            },
            {
                item = 'phone',
                label = 'Celular',
                amount = {min = 1, max = 1},
                chance = 35
            }
        }
    }
}

-- Configurações gerais
Config.SearchTime = 5000 -- Tempo da progressbar em ms
Config.MaxItemsPerSearch = 3 -- Máximo de itens que podem ser encontrados por busca
Config.Cooldown = 30000 -- Cooldown entre buscas no mesmo NPC (30 segundos)
Config.NPCDisappearTime = 180000 -- Tempo para NPC desaparecer após ser revistado (3 minutos = 180000ms)

-- Configurações do inventário do NPC
Config.Inventory = {
    slots = 10, -- Número de slots no inventário do NPC
    maxWeight = 25000, -- Peso máximo do inventário (em gramas)
    label = "Corpo Revistado" -- Nome do inventário
}

-- Configurações das áreas
Config.Areas = {
    enabled = true, -- Ativar/desativar sistema de áreas
    defaultItems = true, -- Usar itens padrão quando não estiver em área específica
    notificationDuration = 3000, -- Duração da notificação de área (ms)
    checkInterval = 2000 -- Intervalo para verificar mudança de área (ms)
}

-- Configurações de animação
Config.Animation = {
    dict = "amb@medic@standing@kneel@base", -- Dicionário da animação
    clip = "base", -- Clip da animação
    flag = 1, -- Flag da animação
    blendIn = 8.0, -- Velocidade de entrada
    blendOut = -8.0 -- Velocidade de saída
}

-- Configurações de distância
Config.Distance = {
    searchRange = 5.0, -- Distância máxima para detectar NPCs mortos
    interactionRange = 3.0, -- Distância máxima para interagir com NPC
    tooFarDistance = 3.0 -- Distância máxima para revistar
}

-- Configurações de notificações
Config.Notifications = {
    enabled = true, -- Ativar/desativar notificações
    position = "top-right", -- Posição das notificações
    sound = true -- Som nas notificações
}

-- Configurações de debug
Config.Debug = {
    enabled = false, -- Ativar/desativar modo debug
    showCoords = false, -- Mostrar coordenadas no console
    showAreaInfo = false -- Mostrar informações da área no console
}

-- Configurações de performance
Config.Performance = {
    npcCheckInterval = 1000, -- Intervalo para verificar NPCs (ms)
    cleanupInterval = 10000, -- Intervalo para limpeza de NPCs (ms)
    maxNPCsPerCheck = 50 -- Máximo de NPCs verificados por vez
}

-- Mensagens
Config.Messages = {
    searching = 'Revistando...',
    found_items = 'Você encontrou alguns itens!',
    nothing_found = 'Não encontrou nada de valor.',
    already_searched = 'Você já revistou este corpo recentemente.',
    too_far = 'Você está muito longe do corpo.',
    npc_disappeared = 'O corpo desapareceu.',
    area_detected = 'Você está em uma área especial!',
    inventory_full = 'Inventário cheio!',
    item_added = 'Item adicionado ao inventário!',
    search_cancelled = 'Revista cancelada!',
    area_entered = 'Entrou em uma área especial!',
    area_left = 'Saiu da área especial!'
}

-- Configurações dos tipos de PED
Config.PedTypes = {
    enabled = true, -- Ativar/desativar sistema de tipos de PED
    priority = "ped", -- Prioridade: "ped" (tipo de PED primeiro) ou "area" (área primeiro)
    fallbackToDefault = true, -- Usar itens padrão se não encontrar tipo específico
    showPedType = true -- Mostrar notificação do tipo de PED encontrado
} 