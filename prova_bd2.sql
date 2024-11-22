-- 1) Crie um usuario que possa realizar todas as operações de DML nas tabelas film, actor e film_actor.

create user delmir@localhost;

grant select, insert, delete, update on prova_bd2.film to delmir@localhost;
grant select, insert, delete, update on prova_bd2.actor to delmir@localhost;
grant select, insert, delete, update on prova_bd2.film_actor to delmir@localhost;

FLUSH PRIVILEGES;

-- 2) Faça uma Procedure que retorne a quantidade de filmes por idioma (language), 
-- apresentando o nome do idioma (name) e a quantidade de filmes. 
-- Apresente apenas os idiomas com mais de 10 filmes.

DELIMITER $$
create procedure pc_quantidade_filmes()
begin
	select count(f.film_id) as quantidade,  l.name
    from film f join language l on l.language_id = f.language_id
    group by l.name
    having count(f.film_id) > 10;
end $$

call pc_quantidade_filmes();

-- 3) Faça uma consulta que liste os títulos dos filmes (title) 
-- que possuem um custo de reposição (replacement_cost) maior que a média de 
-- todos os filmes no banco de dados.

select f.title
from film f
where f.replacement_cost >
			(select avg(f.replacement_cost)
			from film f);
		
-- 4) Crie uma view que realize uma consulta para exibir o número de 
-- filmes em que "Robert Downey" atuou em cada categoria. Apresente o 
-- resultado de forma ordenada pelo maior número de filmes. 
-- Descreva também o comando que executa a view.

create view vw_n_filmes as
select count(f.film_id), c.name
from film f join film_actor fa on fa.film_id = f.film_id
			join actor a on a.actor_id = fa.actor_id
            join film_category fc on fc.film_id = f.film_id
            join category c on c.category_id = fc.category_id
where a.first_name = 'Robert' AND a.last_name = 'Downey'
group by c.name;

SELECT * 
FROM vw_n_filmes
ORDER BY quantFilmes DESC;

-- 5) Faça uma trigger que, ao ser feita a inserção de um filme, define a taxa de 
-- aluguel (rental_rate) em:
		-- 20.00 para filmes lançados em 2024 (release_year),
		-- 15.00 para filmes lançados em 2023,
		-- 10.00 para os demais.

DELIMITER $$

CREATE TRIGGER taxa BEFORE INSERT 
ON film FOR EACH ROW
BEGIN    
    IF NEW.release_year = 2024 THEN 
        SET NEW.rental_rate = 20.00;
    ELSEIF NEW.release_year = 2023 THEN 
        SET NEW.rental_rate = 15.00;
    ELSE 
        SET NEW.rental_rate = 10.00;
    END IF;
END $$

DELIMITER ;



