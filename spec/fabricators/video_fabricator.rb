Fabricator(:video) do
  title {%w(Rick\ and\ Morty Better\ Call\ Saul Futurama).sample}
  description {%w(Desc1 Desc2 Desc3 Desc4).sample}
  category
end
