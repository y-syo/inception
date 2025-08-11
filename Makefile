all:
	mkdir -p /home/mmoussou/data/wp-db /home/mmoussou/data/certs /home/mmoussou/data/wp-site
	docker compose -f ./srcs/docker-compose.yml up -d --build

stop:
	docker compose -f ./srcs/docker-compose.yml stop

clean: stop
	docker system prune -f

fclean: clean
	#sudo rm -Rf /home/mmoussou/data/*/*
	docker system prune -af
	docker volume prune -af

re: fclean
	@$(MAKE) all

.PHONY: all stop clean fclean re
