fuelType = {
    'Wood Logs' : 43.89327,
    'Wood Chips' : 40.58114,
    'Wood Pellets' : 51.56192,
    'Grass/Straw': 57.63342,
    'Coal' : 2904.95,
} #All of this is per tonne
diertyType = {
    'Vegan' : 2.05636,
    'Vegetarian' : 2.5933,
    'Meat Once a Week' : 2.751,
    'Meat 3-4 Times a Week' : 4.699,
    'Meat 5+ Days' : 6.230
}

carTypeMile = {
    'Mini' : 0.2086,
    'SuperMini' : 0.22694,
    'Lower Medium' : 0.26401,
    'Upper Medium' : 0.30808,
    'Executive' : 0.3406,
    'Luxury' : 0.51081,
    'Sports' : 0.38057,
    'Dual Purpose 4x4' : 0.3273,    
    'MPV' : 0.29545,
    'Small Motorbike' : 0.13027,
    'Medium Motorbike' : 0.15813,
    'Large Motorbike' : 0.21037,
    'Average Motorbike' : 0.17925,
    'None' : 0,
}

trainType = { #Per kilometre
    'National Rail' : 0.0351,
    'Internationl Rail' : 0.00441,
    'Light Rail and Traim' : 0.02832,
    'London Underground' : 0.02753
}

busType = {
    'Local London Bus' : 0.07784,
    'Average Local Bus' : 0.10141,
    'Coach' : 0.02669
}

flightType = {
    'Domestic' : 0.27101,
    'Short Haul' : 0.18499,
    'Long Haul' : 0.25998,
    'International' : 0.17493
}

electricityConversion = 0.20496 #this is kWh
gasConversion = 2.03437 #this is cubic metres

def booleanCheck(string):
    if(string != 'Y' and string != 'N'):
        return 'ERROR!, please input either Y or N', False
    return 'Thank you', True

def integerCheck(string):
    try:
        value = int(string)
        if value >= 0:
            return 'Great, Thank you', True
        else:
            return 'ERROR! Please input a non-negative number', False
    except ValueError:
        return 'ERROR! Please input a valid number', False


def main():
    check = False
    name = input("What's your name? \n")

    while (check == False):
        household = input("How many people live in your household?\n")
        message, check = integerCheck(household)
        if(household == '0'):
            check = False
        print(message)
    check = False

    while (check == False):
        green = input('Is your electricity green? Y/N\n')
        message, check = booleanCheck(green)
        print(message)
    check=False
    
    if (green == 'N'):
        while (check == False):
            electricity = input('In kWh how much electricity does your household use in an average month? \n')
            message, check = integerCheck(electricity)
            print(message)
    check = False

    while (check == False):
        solarPanels = input('Do you have solar panels? Y/N\n')
        message, check = booleanCheck(solarPanels)
        print(message)
    check=False

    if (solarPanels == 'Y'):
        while (check == False):
            electricityOffset = input('What percentage of your electricity is offset by your solar panels on an average month? \n')
            message, check = integerCheck(electricityOffset)
            print(message)
    check = False

    while (check == False):
        gas = input('In cubic metres how much gas does your household use on an average month? \n')
        message, check = integerCheck(gas)
        print(message)
    check = False

    while (check == False):
        alternativeHeating = input('Do you use alternative heating? Y/N\n')
        message, check = booleanCheck(alternativeHeating)
        print(message)
    check=False    

    if alternativeHeating == 'Y':
        print('What is your primary alternative fuel source? Enter the respective number that denotes your fuel.')
        for index, fuel in enumerate(fuelType):
            print(fuel, ':', index)
        while True:
            check = False
            while not check:
                primaryFuelType = input()
                message, check = integerCheck(primaryFuelType)
                print(message)
            if 0 <= int(primaryFuelType) < len(fuelType):
                break
            print('ERROR, please select one of the options')
        check = False
        while (check == False):
            fuelQuantity = input('In tonnes how much primary fuel do you burn per year on average?\n')
            message, check = integerCheck(gas)
            print(message)
        check = False
    check = False

    print('What is your average weekly meat consumption?.')
    for index, meat in enumerate(diertyType):
        print(meat, ':', index)
    while True:
        check = False
        while not check:
            primaryDietType = input()
            message, check = integerCheck(primaryDietType)
            print(message)
        if 0 <= int(primaryDietType) < len(diertyType):
            break
        print('ERROR, please select one of the options')


    print('What vehicle do you primarily drive? If none just select None.')
    for index, car in enumerate(carTypeMile):
        print(car, ':', index)
    while True:
        check = False
        while not check:
            primaryCar = input()
            message, check = integerCheck(primaryCar)
            print(message)
        if 0 <= int(primaryCar) < len(carTypeMile):
            break
        print('ERROR, please select one of the options')
    check = False
    while (check == False):
        carMileage = input('How many miles on average do you drive in a month?\n')
        message, check = integerCheck(carMileage)
        print(message)


    print('What type of train do you primarily use? If none just select None.')
    for index, car in enumerate(trainType):
        print(car, ':', index)
    while True:
        check = False
        while not check:
            primaryTrain = input()
            message, check = integerCheck(primaryTrain)
            print(message)
        if 0 <= int(primaryTrain) < len(trainType):
            break
        print('ERROR, please select one of the options')
    check = False
    while (check == False):
        trainDistance = input('How many km on average do you rid ein a month?\n')
        message, check = integerCheck(trainDistance)
        print(message)

    print('What type of bus do you primarily use? If none just select None.')
    for index, bus in enumerate(busType):
        print(bus, ':', index)
    while True:
        check = False
        while not check:
            primaryBus = input()
            message, check = integerCheck(primaryBus)
            print(message)
        if 0 <= int(primaryBus) < len(busType):
            break
        print('ERROR, please select one of the options')
    check = False
    while (check == False):
        busDistance = input('How many km on average do you ride in a month?\n')
        message, check = integerCheck(trainDistance)
        print(message)

    print('What was your primary flight type over the past year? If none just select None.')
    for index, flight in enumerate(flightType):
        print(flight, ':', index)
    while True:
        check = False
        while not check:
            primaryFlight = input()
            message, check = integerCheck(primaryFlight)
            print(message)
        if 0 <= int(primaryFlight) < len(flightType):
            break
        print('ERROR, please select one of the options')
    check = False
    while (check == False):
        flightDistance = input('How many km did you fly for over the last year??\n')
        message, check = integerCheck(trainDistance)
        print(message) #Need to convert hours to km with average plane speed.


    if green == 'Y':
        electricity = 0
    if solarPanels =='N':
        electricityOffset = 0
    if alternativeHeating == 'N':
        fuelQuantity = 0
        primaryFuelType = 0
    electricity = int(electricity)/int(household)
    print(electricity)
    electricity = electricity * electricityConversion * 12 * (1 - (int(electricityOffset)/100)) /1000
    gas = int(gas)/int(household)
    print(gas)
    gas = gas * gasConversion * 12 /1000

    alternativeList = list(fuelType.values())
    primaryFuelValue = alternativeList[int(primaryFuelType)]
    alternativeFuelEmissions = primaryFuelValue * int(fuelQuantity) /1000

    meatList = list(diertyType.values())
    foodtonne = meatList[int(primaryDietType)] * 2 * 365.25 / 1000
    #Should check but average kg of food intake per person each day is 2KG (chat gpt)

    vehicleList = list(carTypeMile.values())
    vehicleTonne = (vehicleList[int(primaryCar)] * int(carMileage) * 12) / 1000
    #going to assume all vehicles use petrol, will need to change

    trainList = list(trainType.values())
    trainTonne = trainList[int(primaryTrain)] * int(trainDistance) * 12 / 1000

    busList = list(busType.values())
    busTonne = busList[int(primaryBus)] * int(busDistance) * 12 / 1000

    flightList = list(flightType.values())
    flightTonne = flightList[int(primaryFlight)] * int(flightDistance) / 1000


    print(name, 'Your total carbon footprint estimation for a year is...')
    print(electricity + gas + alternativeFuelEmissions + foodtonne + vehicleTonne + trainTonne +busTonne + flightTonne)
    print('Breakdown - All Emissions are per year and in tonnes of CO2 released.')
    print('Electricity Emissions: ', electricity)
    print('Gas Emissions: ',gas)
    print('Alternative Fuel Emissions: ', alternativeFuelEmissions)
    print('Food Emissions:', foodtonne)
    print('Vehicle Emissions: ', vehicleTonne)
    print('Train Emissions: ', trainTonne)
    print('Bus Emissions: ', busTonne)
    print('Flight Emissions: ', flightTonne)
    

"""
How to convert dictioary to list and return value of ordered value.
values_list = list(carTypeMile.values())
second_value = values_list[1]

print(second_value)       
""" 
main()
