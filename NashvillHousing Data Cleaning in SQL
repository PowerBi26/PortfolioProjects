Select *
From PortfolioProject..NashvilleHousing


-- CONVERT SALEDATE COLUMN INTO A STANDARD DATE FORMAT AND ADDING A NEW COLUMN FOR THE NEW SALEDATE FORMAT(SaleDateConverted)

Select SaleDate, CONVERT(Date, SaleDate)
From PortfolioProject..NashvilleHousing
 
 Update NashvilleHousing
 Set SaleDate = CONVERT(Date, SaleDate)

 --somehow the code above doesn't work so we made another one using different function
 ALTER TABLE NashvilleHousing
 Add SaleDateConverted Date; --we added a new column in the table named SaleDateConverted, then we update it with the following code below
	
Update NashvilleHousing
 Set SaleDateConverted = CONVERT(Date, SaleDate)
  
Select SaleDateConverted 
From PortfolioProject..NashvilleHousing


-- POPULATE PROPERTY ADDRESS DATA

Select *
From PortfolioProject..NashvilleHousing
Order By ParcelID 


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress,b.PropertyAddress) --if a.propertyaddress is null, we populate it with b.propertyaddress 
From PortfolioProject..NashvilleHousing a 
JOIN PortfolioProject..NashvilleHousing b
 on a.ParcelID = b.ParcelID 
 AND a.[UniqueID ] <> b.[UniqueID ] 
Where a.PropertyAddress is null

Update a 
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a 
JOIN PortfolioProject..NashvilleHousing b
 on a.ParcelID = b.ParcelID 
 AND a.[UniqueID ] <> b.[UniqueID ] 


 -- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMN (Address, City, State)
 
 Select *
 From NashvilleHousing


 Select
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as City
From PortfolioProject..NashvilleHousing 

 ALTER TABLE NashvilleHousing
 Add PropertySplitAddress Nvarchar(255); 

Update NashvilleHousing
 Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

 
 ALTER TABLE NashvilleHousing
 Add PropertySplitCity Nvarchar(255); 

Update NashvilleHousing
 Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

 -- SIMPLER WAY TO BREAK OUT ADDRESS INTO INDIVIDUAL COLUMN (Address, City, State) USING PARSENAME FUNCTION

 Select 
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1), --PARSENAME only works with '.' values so we changed commas to periods using the REPLACE function
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 
 From PortfolioProject..NashvilleHousing

 --PARSENAME does things backwards
  Select 
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3), 
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)  
 From PortfolioProject..NashvilleHousing

 
 ALTER TABLE NashvilleHousing
 Add OwnerSplitAddress Nvarchar(255); 

Update NashvilleHousing
 Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

 
 ALTER TABLE NashvilleHousing
 Add OwnerSplitCity Nvarchar(255); 

Update NashvilleHousing
 Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

 
 ALTER TABLE NashvilleHousing
 Add OwnerSplitState Nvarchar(255); 

Update NashvilleHousing
 Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


 -- CHANGE Y AND N TO YES AND NO IN SoldAsVacant COLUMN 
 
 Select DISTINCT SoldAsVacant
 From NashvilleHousing

  Select DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
 From NashvilleHousing
 Group By SoldAsVacant 
 Order By 2

 Select SoldAsVacant, 
  CASE --using CASE  statement
  When SoldAsVacant = 'Y' then 'Yes'
  When SoldAsVacant = 'N' then 'No'
  Else SoldAsVacant
  END
 From NashvilleHousing

 Update NashvilleHousing 
 Set SoldAsVacant = CASE 
  When SoldAsVacant = 'Y' then 'Yes'
  When SoldAsVacant = 'N' then 'No'
  Else SoldAsVacant
  END


  -- REMOVE DUPLICATES
 

 WITH RowNumCTE as ( 
 Select *,
 ROW_NUMBER() OVER (
	PARTITION BY
	ParcelID,
	PropertyAddress,
	Saledate,
	LegalReference
	Order By UniqueID
	) row_num
From PortfolioProject..NashvilleHousing
--Order By ParcelID\
)
Select * --to delete the data that is returned by this script, we just changed the SELECT * script to DELETE and executed it then returned the SELECT * to check the outcome
From RowNumCTE
Where row_num > 1--we used CTE to query this script
Order By PropertyAddress 



-- DELETE UNUSED COLUMNS

Select *
From PortfolioProject..NashvilleHousing 


ALTER TABLE PortfolioProject..NashvilleHousing 
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict, PropertSPlitAddress, SaleDate

