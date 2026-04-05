period_of_ElNino = 7 #This is the fundamental period and it is typically between 5-7 years
growth_factor_normal = 1.188 #18.8% growth is exhibited in a normal year
growth_factor_ElNino = 0.381 #-69% increase (69 % decrease) is exhibited in an El Nino year

duration_of_observation = 100 #years
quasi_exinction_threshold = 10 #individuals. Once the population reaches this number it is essentially extinct (meaning it can no longer recover)
starting_population = 500 #individuals
maximum_carrying_capacity = 2000 #individuals

function generate_population_trajectory(starting_population)
    population_trajectory = Int64[starting_population] 

    for i in 2:duration_of_observation

        growth_factor = growth_factor_normal
        if rand() < 1/period_of_ElNino; growth_factor = growth_factor_ElNino; end 

        current_population = round(population_trajectory[i-1] * growth_factor)
        if current_population > maximum_carrying_capacity; current_population = maximum_carrying_capacity; end
        if current_population <= quasi_exinction_threshold; current_population = 0; end

        push!(population_trajectory, current_population)
            
    end
    return population_trajectory
end 

population_trajectory = generate_population_trajectory(starting_population)

using CairoMakie

fig = Figure(size = (800, 500))
ax = Axis(fig.layout[1, 1])
ax.limits = ((0, duration_of_observation + 20), (0, maximum_carrying_capacity + 500))
ax.xlabel[] = "Years"
ax.ylabel[] = "Population Size"

lines!(ax, 0:length(population_trajectory)-1, population_trajectory)
scatter!(ax, 0:length(population_trajectory)-1, population_trajectory; marker = :circle, markersize = 10)
fig





