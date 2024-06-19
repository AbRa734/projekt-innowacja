global class ScheduledGetMissingAnimals implements Schedulable{
    global void execute(SchedulableContext SC) {
        MissingAnimalsManager.getMissingAnimals();
    }
}