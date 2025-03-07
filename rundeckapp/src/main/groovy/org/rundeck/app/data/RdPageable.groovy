package org.rundeck.app.data

import groovy.transform.CompileStatic
import org.rundeck.app.data.model.v1.page.Pageable

@CompileStatic
class RdPageable implements Pageable{

    Integer offset
    Integer max
    List<RdSortOrder> sortOrders = [];

    RdPageable withOrder(String column, String sortDir) {
        sortOrders.add(new RdSortOrder(column:column,direction: sortDir))
        return this
    }

}
