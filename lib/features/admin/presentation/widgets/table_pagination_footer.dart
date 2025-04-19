import 'package:flutter/material.dart';
import 'package:variant_master/core/theme/app_colors.dart';

class TablePaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int rowsPerPage;
  final Function(int) onPageChanged;
  final Function(int) onRowsPerPageChanged;
  final List<int> availableRowsPerPage;

  const TablePaginationFooter({
    super.key,
    required this.currentPage,
    required this.totalItems,
    required this.rowsPerPage,
    required this.onPageChanged,
    required this.onRowsPerPageChanged,
    this.availableRowsPerPage = const [5, 10, 20, 50],
  });

  int get _startIndex => currentPage * rowsPerPage;
  int get _endIndex => (_startIndex + rowsPerPage) > totalItems
      ? totalItems
      : _startIndex + rowsPerPage;
  bool get _hasNextPage => _endIndex < totalItems;
  int get _maxPage => (totalItems / rowsPerPage).ceil() - 1;
  bool get _hasPreviousPage => currentPage > 0;

  // Generate page numbers to display
  List<int> get _pageNumbers {
    const int maxVisiblePages = 5; // Maximum number of page buttons to show
    
    if (_maxPage < maxVisiblePages) {
      // If total pages are less than max visible, show all pages
      return List.generate(_maxPage + 1, (index) => index);
    }
    
    // Calculate range of pages to show
    int startPage = currentPage - (maxVisiblePages ~/ 2);
    int endPage = currentPage + (maxVisiblePages ~/ 2);
    
    // Adjust if out of bounds
    if (startPage < 0) {
      endPage += -startPage;
      startPage = 0;
    }
    
    if (endPage > _maxPage) {
      startPage -= (endPage - _maxPage);
      endPage = _maxPage;
    }
    
    // Ensure startPage is not negative after adjustments
    startPage = startPage < 0 ? 0 : startPage;
    
    return List.generate(endPage - startPage + 1, (index) => startPage + index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Items info
          Text(
            totalItems > 0 
                ? '${_startIndex + 1}-$_endIndex / $totalItems'
                : 'Ma\'lumot topilmadi',
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),
          
          // Pagination controls
          Row(
            children: [
              // Rows per page dropdown
              Row(
                children: [
                  const Text(
                    'Qatorlar: ',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: DropdownButton<int>(
                      value: rowsPerPage,
                      underline: Container(),
                      isDense: true,
                      items: availableRowsPerPage
                          .map((count) => DropdownMenuItem<int>(
                                value: count,
                                child: Text('$count'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onRowsPerPageChanged(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              
              // Page navigation
              Row(
                children: [
                  // First page button
                  _buildPageButton(
                    icon: Icons.first_page,
                    onPressed: _hasPreviousPage ? () => onPageChanged(0) : null,
                    isActive: _hasPreviousPage,
                  ),
                  
                  // Previous page button
                  _buildPageButton(
                    icon: Icons.chevron_left,
                    onPressed: _hasPreviousPage ? () => onPageChanged(currentPage - 1) : null,
                    isActive: _hasPreviousPage,
                  ),
                  
                  // Page numbers
                  ..._pageNumbers.map((pageNumber) => _buildNumberButton(
                    pageNumber: pageNumber,
                    isActive: pageNumber == currentPage,
                    onPressed: () => onPageChanged(pageNumber),
                  )),
                  
                  // Next page button
                  _buildPageButton(
                    icon: Icons.chevron_right,
                    onPressed: _hasNextPage ? () => onPageChanged(currentPage + 1) : null,
                    isActive: _hasNextPage,
                  ),
                  
                  // Last page button
                  _buildPageButton(
                    icon: Icons.last_page,
                    onPressed: _hasNextPage ? () => onPageChanged(_maxPage) : null,
                    isActive: _hasNextPage,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPageButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              icon,
              size: 20,
              color: isActive ? AppColors.primary : const Color(0xFFD1D5DB),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNumberButton({
    required int pageNumber,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: isActive ? null : onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            child: Text(
              '${pageNumber + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF6B7280),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
