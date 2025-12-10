SELECT 
    n.nid as order_id,
    n.title as order_number,
    FROM_UNIXTIME(n.created, '%d.%m.%Y') as order_date,
    FROM_UNIXTIME(n.created, '%H:%i:%s') as order_time,
    
    -- Shipping information
    fd_name.field_dodaci_jmeno_value as shipping_name,
    fd_surname.field_dodaci_prijmeni_value as shipping_surname,
    fd_street.field_dodaci_ulice_value as shipping_street,
    fd_city.field_dodaci_mesto_value as shipping_city,
    fd_zip.field_dodaci_psc_value as shipping_zip,
    fd_phone.field_dodaci_telefon_value as shipping_phone,
    td_state.name as shipping_state,
    fd_company.field_dodaci_nazev_firmy_value as shipping_company,
    
    -- Billing information
    fb_name.field_fakturacni_jmeno_value as billing_name,
    fb_surname.field_fakturacni_prijmeni_value as billing_surname,
    fb_street.field_fakturacni_ulice_value as billing_street,
    fb_city.field_fakturacni_mesto_value as billing_city,
    fb_zip.field_fakturacni_psc_value as billing_zip,
    fu_phone.field_user_telefon_value as billing_phone,
    tb_state.name as billing_state,
    fb_company.field_fakturacni_nazev_firmy_value as billing_company,
    fb_ico.field_fakturacni_ic_value as billing_ico,
    fb_dic.field_fakturacni_dic_value as billing_dic,
    
    -- User information
    u.mail as user_mail,
    fu_email.field_user_email_email as contact_mail,
    
    -- Order details
    fo_shipping.field_obejdnavka_doprava_nazev_value as shipping_method,
    fo_ship_price.field_objednavka_doprava_cena_value as shipping_price,
    fo_pay_method.field_objednavka_platba_nazev_value as billing_method,
    fo_pay_price.field_objednavka_platba_cena_value as billing_price,
    fo_total.field_objednavka_celkova_cena_value as total_price,
    fo_note.field_objednavka_poznamka_value as order_note,
    
    -- Product information
    np.title as product_name,
    fp_weight.field_obj_pr_hmotnost_celkem_value as total_weight,
    fp_daily.field_obj_pr_hmotnost_davky_value as daily_portion,
    fp_price.field_produkt_cena_s_dph_value as price,
    
    -- Dog information
    fp_dog_name.field_obj_pr_jmeno_mazlicka_value as dog_name,
    FROM_UNIXTIME(fp_dog_date.field_obj_pr_datum_narozeni_value, '%d. %m. %Y') as dog_birth_date,
    fd_weight.field_mazlicek_hmotnost_value as dog_weight,
    CASE fd_allergies.field_mazlicek_je_alergik_value 
        WHEN 1 THEN 'Ano' 
        ELSE 'Ne' 
    END as has_allergies

FROM node n
JOIN users u ON n.uid = u.uid
LEFT JOIN field_data_field_dodaci_jmeno fd_name ON n.nid = fd_name.entity_id
LEFT JOIN field_data_field_dodaci_prijmeni fd_surname ON n.nid = fd_surname.entity_id
LEFT JOIN field_data_field_dodaci_ulice fd_street ON n.nid = fd_street.entity_id
LEFT JOIN field_data_field_dodaci_mesto fd_city ON n.nid = fd_city.entity_id
LEFT JOIN field_data_field_dodaci_psc fd_zip ON n.nid = fd_zip.entity_id
LEFT JOIN field_data_field_dodaci_telefon fd_phone ON n.nid = fd_phone.entity_id
LEFT JOIN field_data_field_dodaci_stat fd_state ON n.nid = fd_state.entity_id
LEFT JOIN taxonomy_term_data td_state ON fd_state.field_dodaci_stat_tid = td_state.tid
LEFT JOIN field_data_field_dodaci_nazev_firmy fd_company ON n.nid = fd_company.entity_id

LEFT JOIN field_data_field_fakturacni_jmeno fb_name ON n.nid = fb_name.entity_id
LEFT JOIN field_data_field_fakturacni_prijmeni fb_surname ON n.nid = fb_surname.entity_id
LEFT JOIN field_data_field_fakturacni_ulice fb_street ON n.nid = fb_street.entity_id
LEFT JOIN field_data_field_fakturacni_mesto fb_city ON n.nid = fb_city.entity_id
LEFT JOIN field_data_field_fakturacni_psc fb_zip ON n.nid = fb_zip.entity_id
LEFT JOIN field_data_field_user_telefon fu_phone ON n.nid = fu_phone.entity_id
LEFT JOIN field_data_field_fakturacni_stat fb_state ON n.nid = fb_state.entity_id
LEFT JOIN taxonomy_term_data tb_state ON fb_state.field_fakturacni_stat_tid = tb_state.tid
LEFT JOIN field_data_field_fakturacni_nazev_firmy fb_company ON n.nid = fb_company.entity_id
LEFT JOIN field_data_field_fakturacni_ic fb_ico ON n.nid = fb_ico.entity_id
LEFT JOIN field_data_field_fakturacni_dic fb_dic ON n.nid = fb_dic.entity_id

LEFT JOIN field_data_field_user_email fu_email ON n.nid = fu_email.entity_id
LEFT JOIN field_data_field_obejdnavka_doprava_nazev fo_shipping ON n.nid = fo_shipping.entity_id
LEFT JOIN field_data_field_objednavka_doprava_cena fo_ship_price ON n.nid = fo_ship_price.entity_id
LEFT JOIN field_data_field_objednavka_platba_nazev fo_pay_method ON n.nid = fo_pay_method.entity_id
LEFT JOIN field_data_field_objednavka_platba_cena fo_pay_price ON n.nid = fo_pay_price.entity_id
LEFT JOIN field_data_field_objednavka_celkova_cena fo_total ON n.nid = fo_total.entity_id
LEFT JOIN field_data_field_objednavka_poznamka fo_note ON n.nid = fo_note.entity_id

LEFT JOIN field_data_field_objednavka_produkty fo_products ON n.nid = fo_products.entity_id
LEFT JOIN node np ON fo_products.field_objednavka_produkty_nid = np.nid
LEFT JOIN field_data_field_obj_pr_hmotnost_celkem fp_weight ON np.nid = fp_weight.entity_id
LEFT JOIN field_data_field_obj_pr_hmotnost_davky fp_daily ON np.nid = fp_daily.entity_id
LEFT JOIN field_data_field_produkt_cena_s_dph fp_price ON np.nid = fp_price.entity_id
LEFT JOIN field_data_field_obj_pr_jmeno_mazlicka fp_dog_name ON np.nid = fp_dog_name.entity_id
LEFT JOIN field_data_field_obj_pr_datum_narozeni fp_dog_date ON np.nid = fp_dog_date.entity_id

LEFT JOIN field_data_field_nid_mazlicka_reference fp_dog_ref ON np.nid = fp_dog_ref.entity_id
LEFT JOIN node nd ON fp_dog_ref.field_nid_mazlicka_reference_nid = nd.nid
LEFT JOIN field_data_field_mazlicek_hmotnost fd_weight ON nd.nid = fd_weight.entity_id
LEFT JOIN field_data_field_mazlicek_je_alergik fd_allergies ON nd.nid = fd_allergies.entity_id

WHERE n.type = 'objednavka'
  AND n.status = 1
ORDER BY n.created DESC;