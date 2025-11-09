AFK = AFK or {}

-- Temps d'inactivité avant le premier warning (en secondes)
AFK.warnTime = 60 * 5       -- 5 minutes

-- Temps d'inactivité total avant kick (en secondes)
AFK.kickTime = 60 * 6       -- 6 minutes (1 minute après le warning)

-- Intervalle de vérification (ms)
AFK.checkInterval = 5000    -- 5s

-- Distance minimale de déplacement pour considérer que le joueur bouge (en mètres)
AFK.minMoveDistance = 0.1

-- Messages affichés
AFK.warningMessage = "Vous allez être kick pour AFK dans %s secondes. Bougez pour annuler."
AFK.kickedMessage = "Vous avez été kick pour inactivité (AFK)."

-- Whitelist: steam hex identifiers ou autres identifiers (laisser vide si pas besoin)
AFK.whitelist = {
    -- "steam:xxxxxxxxxxxxx",
}

-- Kick reason (peut être changé)
AFK.kickReason = "AFK"