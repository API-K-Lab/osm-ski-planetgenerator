ifeq ($(PLANETILER_OPTIONS),)
PLANETILER_OPTIONS = -Xmx1g
endif

DATA_DIR = $(CURDIR)/data

all: ski-france

ski-%: $(DATA_DIR)/schema-%.yml
	echo "Generating $@"
	docker run -v "$(DATA_DIR)":/data ghcr.io/onthegomap/planetiler:latest generate-custom --schema=/data/$(shell basename $<) --download $(PLANETILER_OPTIONS) mbtiles=/data/ski-$*.mbtiles
	mv $(DATA_DIR)/output.mbtiles $(DATA_DIR)/ski-$*.mbtiles

$(DATA_DIR)/schema-%.yml:
	echo "Generating $@"
	sed 's/{area}/$*/g' ./schema.yml > $@

$(DATA_DIR)/schema-planet.yml:
	echo "Generating planet"
	sed 's/url: geofabrik:{area}/url: https:\/\/planet\.osm\.org\/pbf\/planet-latest\.osm\.pbf/g' ./schema.yml > $(DATA_DIR)/schema-planet.yml