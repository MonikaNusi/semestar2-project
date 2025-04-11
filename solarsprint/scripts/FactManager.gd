extends Node

var facts = [
	"Wind turbines in Ireland generate enough energy to power 2 million homes.",
	"Wexford is part of Ireland’s plan to be carbon neutral by 2050.",
	"Solar energy is a clean, renewable power source.",
	"Wexford’s Rosslare Harbour is planned to support offshore wind farms.",
	"Using public transport reduces carbon footprint.",
	"Trees absorb CO2 and produce oxygen — plant more!",
	"Solar energy systems do not produce air pollution, water pollution, 
	or greenhouse gases, making them a clean and sustainable energy source",
	"Solar panels can generate electricity even on cloudy days, 
	as they rely on daylight rather than direct sunlight",
	"The first solar cell was invented in the 1800s, 
	marking the beginning of harnessing solar energy for electricity.",
	"Farmers in Wexford are increasingly adopting solar panels to power
	agricultural operations, reducing energy costs and environmental impact.",
	"Several public buildings in Wexford have installed solar panels
	 to decrease reliance on fossil fuels and lower operational costs.",
	"Some solar vehicles can achieve speeds comparable to traditional cars.",
	"Some solar cars can run for months without ever needing a charge.",
	"Driving a solar car can cut yearly fuel costs to near zero.",
	"Some solar cars are so efficient, they use less energy than a hairdryer.",
	"Solar vehicles are tested in deserts due to high sun exposure.",
]

var last_index := -1

func get_random_fact() -> String:
	if facts.is_empty():
		return "No facts available."

	var new_index := randi() % facts.size()
	while new_index == last_index and facts.size() > 1:
		new_index = randi() % facts.size()
	last_index = new_index
	return facts[new_index]
