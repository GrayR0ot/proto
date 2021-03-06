package com.ankamagames.dofus.logic.game.common.actions.alliance
{
   import com.ankamagames.dofus.misc.utils.AbstractAction;
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class SetEnableAVARequestAction extends AbstractAction implements Action
   {
       
      
      public var enable:Boolean;
      
      public function SetEnableAVARequestAction(params:Array = null)
      {
         super(params);
      }
      
      public static function create(enable:Boolean) : SetEnableAVARequestAction
      {
         var action:SetEnableAVARequestAction = new SetEnableAVARequestAction(arguments);
         action.enable = enable;
         return action;
      }
   }
}
