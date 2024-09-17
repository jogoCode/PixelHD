extends triggerAction
class_name TriggerActionTuto;

func action(area):
	GameManager._tutoDone = true;
	Level.save_score();
	Level.main._tuto_finished();
