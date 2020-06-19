/*
 * Official resource topic: https://dev-cs.ru/resources/1015/
 */

#include <amxmodx>
#include <reapi>

#pragma semicolon 1

public stock const PluginName[] = "Free Armor";
public stock const PluginVersion[] = "1.0.0";
public stock const PluginAuthor[] = "twisterniq";
public stock const PluginURL[] = "https://github.com/twisterniq/amxx-free-armor";
public stock const PluginDescription[] = "Adds the possibility to make each player spawn with armor and a helmet.";

new const CONFIG_NAME[] = "free_armor";

enum _:CVARS
{
	ArmorType:CVAR_ARMOR_T,
	CVAR_ARMOR_T_AMOUNT,
	ArmorType:CVAR_ARMOR_CT,
	CVAR_ARMOR_CT_AMOUNT,
	CVAR_ARMOR_BOTS
};

new g_iCvar[CVARS];

public plugin_init()
{
#if AMXX_VERSION_NUM == 190
	register_plugin(
		.plugin_name = PluginName,
		.version = PluginVersion,
		.author = PluginAuthor
	);
#endif

	register_dictionary("free_armor.txt");

	RegisterHookChain(RG_CBasePlayer_OnSpawnEquip, "@OnSpawnEquip_Post", .post = true);

	bind_pcvar_num(create_cvar(
		.name = "free_armor_t",
		.string = "1",
		.flags = FCVAR_NONE,
		.description = fmt("%L", LANG_SERVER, "FREE_ARMOR_T"),
		.has_min = true,
		.min_val = 0.0,
		.has_max = true,
		.max_val = 2.0), g_iCvar[CVAR_ARMOR_T]);

	bind_pcvar_num(create_cvar(
		.name = "free_armor_t_amount",
		.string = "100",
		.flags = FCVAR_NONE,
		.description = fmt("%L", LANG_SERVER, "FREE_ARMOR_T_AMOUNT"),
		.has_min = true,
		.min_val = 0.0,
		.has_max = true,
		.max_val = 999.9), g_iCvar[CVAR_ARMOR_T_AMOUNT]);

	bind_pcvar_num(create_cvar(
		.name = "free_armor_ct",
		.string = "1",
		.flags = FCVAR_NONE,
		.description = fmt("%L", LANG_SERVER, "FREE_ARMOR_CT"),
		.has_min = true,
		.min_val = 0.0,
		.has_max = true,
		.max_val = 2.0), g_iCvar[CVAR_ARMOR_CT]);
	
	bind_pcvar_num(create_cvar(
		.name = "free_armor_ct_amount",
		.string = "100",
		.flags = FCVAR_NONE,
		.description = fmt("%L", LANG_SERVER, "FREE_ARMOR_CT_AMOUNT"),
		.has_min = true,
		.min_val = 0.0,
		.has_max = true,
		.max_val = 999.9), g_iCvar[CVAR_ARMOR_CT_AMOUNT]);

	bind_pcvar_num(create_cvar(
		.name = "free_armor_bots",
		.string = "1",
		.flags = FCVAR_NONE,
		.description = fmt("%L", LANG_SERVER, "FREE_ARMOR_BOTS"),
		.has_min = true,
		.min_val = 0.0,
		.has_max = true,
		.max_val = 1.0), g_iCvar[CVAR_ARMOR_BOTS]);

	AutoExecConfig(true, CONFIG_NAME);

	new szPath[PLATFORM_MAX_PATH];
	get_localinfo("amxx_configsdir", szPath, charsmax(szPath));
	server_cmd("exec %s/plugins/%s.cfg", szPath, CONFIG_NAME);
	server_exec();
}

@OnSpawnEquip_Post(const id, bool:bAddDefault, bool:bEquipGame)
{
	if (!g_iCvar[CVAR_ARMOR_BOTS] && is_user_bot(id))
	{
		return;
	}

	new TeamName:iTeam = get_member(id, m_iTeam);

	switch (iTeam)
	{
		case TEAM_TERRORIST:
		{
			if (g_iCvar[CVAR_ARMOR_T])
			{
				rg_set_user_armor(id, g_iCvar[CVAR_ARMOR_T_AMOUNT], g_iCvar[CVAR_ARMOR_T]);
			}
		}
		case TEAM_CT:
		{
			if (g_iCvar[CVAR_ARMOR_CT])
			{
				rg_set_user_armor(id, g_iCvar[CVAR_ARMOR_CT_AMOUNT], g_iCvar[CVAR_ARMOR_CT]);
			}
		}
	}
}