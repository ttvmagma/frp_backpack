ALTER TABLE `users` 
ADD COLUMN IF NOT EXISTS `backpack` INT(11) NULL DEFAULT '0';