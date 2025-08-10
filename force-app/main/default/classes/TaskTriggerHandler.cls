public class TaskTriggerHandler {
    public static void SetPriorityHighWhenTaskCreat(list<Task> newRec){
        for(task tk : newRec){
            system.debug('record enter in trigger');
            tk.Priority = 'high';
            system.debug('record is at the end of trigger');
        }
    }
}