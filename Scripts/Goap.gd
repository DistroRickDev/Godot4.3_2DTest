
enum Priority {LOWEST, LOW, MEDIUM, HIGH, HIGHEST}

class Goal:
	var goal_id: String
	var priority: Priority

class Action:
	var action_id: String
	var precondition : Dictionary
	var effect : Dictionary

class Plan:
	var objective: Goal
	var plan_actions: Array[Goal]

class Agent:
	var current_plan: Plan
