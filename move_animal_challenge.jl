using RData#Used here to read files in *.rds format
using DataFrames#Used here to manipulate the DataFrames
using CSV#Used here to export the results in CSV

# Reads the data from the file "movements.rds"
movements = load("data/movements.rds",convert=true)

#Creates an empty new DataFrame
population = DataFrame();

# Add a new column named "premiseid" with values given by the columns "new_originpremid"
#and "new_destinationpremid" of dataframe movements.
population."premiseid" = [movements."new_originpremid";
                          movements."new_destinationpremid"];

# Add a new column named "total_animal" with values equal to the integer number 1000
population."total_animal" .= 1000;

#=================================#
#      create the function    ----
#=================================#  
function move_animal_fun!(population, origin, destination, animals)
    #Remove the animals from the origin_farm
    @inbounds for item in origin
        population.total_animal[findfirst(.==(item), population.premiseid)] -= animals[findfirst(.==(item), population.premiseid)]
    end
    # Adds the animals to the destination_farm
    @inbounds for item in destination
        population.total_animal[findfirst(.==(item), population.premiseid)] += animals[findfirst(.==(item), population.premiseid) - length(population.premiseid) ÷ 2]
    end
    return population
end

#=================================#
#      test the function      ----
#=================================#
# Set the parameters
origin = movements."new_originpremid";
destination = movements."new_destinationpremid";
animals = movements."new_numitemsmoved";

# run the function ----
move_animal_fun!(population, origin, destination, animals);

CSV.write("./data/population_julia.csv",population; quotestrings=true)
