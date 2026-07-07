extends Control

var villager_data = {}
var file = "res://assets/strings/dialogue.json"
var json_as_text = FileAccess.get_file_as_string(file)
var dialogue_options = JSON.parse_string(json_as_text)
enum hunger {HEALTHY, HUNGRY, DEAD}
enum financial_status {POOR, AVERAGE, WEALTHY}
var villagers = dialogue_options.keys()
var villagers_alive = 0
var rng = RandomNumberGenerator.new()
var current_customer

# Called when the node enters the scene tree for the first time.
func _ready():
	for villager in villagers:
		villager_data[villager] = {}
		villager_data[villager].dialogue = dialogue_options[villager]
		villager_data[villager].hunger = hunger.HEALTHY
		villager_data[villager].financial_status = financial_status.AVERAGE
		villagers_alive += 1
	print(villager_data)

func open_shop():
	var customer_count = _calc_customer_count()
	if customer_count == 0:
		DialogManager.add_to_queue("Nobody showed up")
	else:
		var options = _get_living_villagers()
		var customers = []
		for index in range(customer_count):
			var customer = options.pick_random()
			customers.append(customer)
			options.remove_at(options.find(customer))
		for customer in customers:
			current_customer = customer
			_haggle()
	
func _calc_customer_count():
	var min_customers = int(ceil(villagers_alive / 4.0))
	var max_customers = int(ceil(villagers_alive / 2.0))
	print(min_customers, max_customers)
	return rng.randi_range(min_customers, max_customers)
	
func _get_living_villagers():
	var living_villagers = []
	for villager in villager_data:
		if villager_data[villager].hunger != hunger.DEAD:
			living_villagers.append(villager)
	return living_villagers

func _haggle():
	DialogManager.add_to_queue(villager_data[current_customer].dialogue.haggling.greeting.pick_random(), current_customer)
	DialogManager.add_to_queue(_generate_offer(), current_customer, true)
	
func _generate_offer():
	var min_budget
	var max_budget
	var min_purchase
	var max_purchase
	if villager_data[current_customer].financial_status == financial_status.POOR:
		min_budget = 1
		max_budget = 10
		min_purchase = 1
		max_purchase = 3
	elif villager_data[current_customer].financial_status == financial_status.AVERAGE:
		min_budget = 5
		max_budget = 25
		min_purchase = 1
		max_purchase = 8
	else:
		min_budget = 10
		max_budget = 50
		min_purchase = 2
		max_purchase = 10
	return "Could I get " + str(rng.randi_range(min_purchase, max_purchase)) + " bento for $" + str(rng.randi_range(min_budget, max_budget)) + "?"
	
func accept_offer():
	if villager_data[current_customer].hunger == hunger.HEALTHY:
		DialogManager.add_to_queue(villager_data[current_customer].dialogue.haggling.offer_accepted.not_hungry.pick_random(), current_customer)
	else:	
		DialogManager.add_to_queue(villager_data[current_customer].dialogue.haggling.offer_accepted.hungry.pick_random(), current_customer)

func decline_offer():
	if villager_data[current_customer].hunger == hunger.HEALTHY:
		DialogManager.add_to_queue(villager_data[current_customer].dialogue.haggling.offer_declined.not_hungry.pick_random(), current_customer)
	else:	
		DialogManager.add_to_queue(villager_data[current_customer].dialogue.haggling.offer_declined.hungry.pick_random(), current_customer)
