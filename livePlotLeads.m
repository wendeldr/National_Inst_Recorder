function livePlotLeads(time, data, fig, name)
    figure(fig)
    %set(0, 'currentfigure', fig)
    plot(time, data);
    title(name);
end
