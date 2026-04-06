# written by Alexandra Predescu on 4/5/2026

const period_of_ElNino = 7 #This is the fundamental period and it is typically between 5-7 years
const growth_factor_normal = 1.188 #18.8% growth is exhibited in a normal year
const growth_factor_ElNino = 0.381 #-69% increase (69 % decrease) is exhibited in an El Nino year

const duration_of_observation = 100 #years
const quasi_exinction_threshold = 10 #individuals. Once the population reaches this number it is essentially extinct (meaning it can no longer recover)
const starting_population = 500 #individuals
const maximum_carrying_capacity = 2000 #individuals

function generate_population_trajectory(period_of_ElNino = period_of_ElNino, starting_population = starting_population)
    population_trajectory = Int64[starting_population] 

    for i in 2:duration_of_observation
        growth_factor = rand() < 1/period_of_ElNino ? growth_factor_ElNino : growth_factor_normal

        current_population = round(population_trajectory[i-1] * growth_factor)
        #if current_population > maximum_carrying_capacity; current_population = maximum_carrying_capacity; end
        #if current_population <= quasi_exinction_threshold; current_population = 0; end

        # The two lines commented out above are equivalent to the following expression using the ternary conditional operator
        current_population = current_population > maximum_carrying_capacity ? maximum_carrying_capacity : current_population
        current_population = current_population ≤ quasi_exinction_threshold ? 0 : current_population

        push!(population_trajectory, current_population)  
    end
    return population_trajectory
end 

function count_extinction_events(number_of_iterations, period_of_ElNino = period_of_ElNino, starting_population = starting_population)
    number_of_extinction_events = 0
    for i ∈ 1:number_of_iterations
        population_trajectory = generate_population_trajectory(period_of_ElNino, starting_population)
        if 0 ∈ population_trajectory
            number_of_extinction_events = number_of_extinction_events + 1
        end    
    end 
    return number_of_extinction_events
end 



number_of_extinction_events = count_extinction_events(1000000, 3, starting_population)
println("The number of extinction events is $number_of_extinction_events")

using CairoMakie

population_trajectory = generate_population_trajectory(period_of_ElNino, starting_population)

fig = Figure(size = (800, 500))
ax = Axis(fig.layout[1, 1])
ax.limits = ((0, duration_of_observation + 20), (0, maximum_carrying_capacity + 500))
ax.xlabel[] = "Years"
ax.ylabel[] = "Population Size"

lines!(ax, 0:length(population_trajectory)-1, population_trajectory)
scatter!(ax, 0:length(population_trajectory)-1, population_trajectory; marker = :circle, markersize = 10)
fig
save("population_viability_analysis_graph_example.pdf", fig)




