

ALTER TABLE services 
  ADD CONSTRAINT services_category_id_fk
    FOREIGN KEY (category_id) REFERENCES categories(id)
      ON DELETE CASCADE;


ALTER TABLE users 
  ADD CONSTRAINT users_access_level_id_fk
    FOREIGN KEY (access_level_id) REFERENCES access_levels(id)
      ON DELETE CASCADE;

ALTER TABLE profiles 
  ADD CONSTRAINT profiles_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;

ALTER TABLE access_levels_services 
  ADD CONSTRAINT access_levels_services_access_level_id_fk
    FOREIGN KEY (access_level_id) REFERENCES access_levels(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT access_levels_services_service_id_fk
    FOREIGN KEY (service_id) REFERENCES services(id)
      ON DELETE CASCADE;   

ALTER TABLE orders 
  ADD CONSTRAINT orders_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT orders_service_id_fk
    FOREIGN KEY (service_id) REFERENCES services(id)
      ON DELETE CASCADE;
     
ALTER TABLE emails 
  ADD CONSTRAINT emails_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
ALTER TABLE payments   
  ADD CONSTRAINT payments_order_id_fk
    FOREIGN KEY (order_id) REFERENCES orders(id)
      ON DELETE CASCADE;
     
ALTER TABLE articles 
  ADD CONSTRAINT articles_category_id_fk
    FOREIGN KEY (category_id) REFERENCES categories(id)
      ON DELETE CASCADE;

      
     










 


 






   
